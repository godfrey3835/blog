---
layout: post
title: 'RightAws: Generate S3 GetObject Link with response-* parameters'
published: true
date: 2011-02-01 00:00
tags: []
categories: []
redirect_from: /posts/2011/02/01/rightaws-get-link-response
comments: true

---

Recently (on Jan 14, 2011), Amazon AWS has added&nbsp;Response Header API Support to their S3 API (see <a href="http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectGET.html" target="_blank">Get Object</a>). &nbsp;However, the Ruby library <a href="https://github.com/rightscale/right_aws" target="_blank">RightAws</a> doesn't support this feature yet. &nbsp;<del>As an open-source developer,</del> I implemented the code by myself, and also sent a pull request to the original developer.

The <code>response-content-disposition</code> parameter also supports filename assignment.  As a native Chinese speaker, I've tested it with non-ascii filenames, so you can use <code>response-content-disposition=attachment; filename=my favorite song.mp3</code> in English, <code>ma chanson préférée.mp3</code> in French or even <code>我尚佮意ㄟ一條歌.mp3</code> in Taiwanese.

The commits are also listed on the <a href="https://github.com/rightscale/right_aws/pull/47" target="_blank">pull request page</a>, but if you want to make it available for your project without modifying the gem-installed codes in your machine, you could do method-overloading. &nbsp;Sample codes are available below.

BTW, I know that my coding style is not good, so feel free fork <a href="https://github.com/chitsaou/right_aws" target="_blank">my project</a> or the <a href="https://github.com/rightscale/right_aws" target="_blank">original RightAws</a> and prettify the code :p

<!--more-->

[sourcecode language="ruby"]<br />
#!/usr/local/bin/ruby<br />
# Distributed under the same license of the original right_aws software,<br />
# see https://github.com/rightscale/right_aws/blob/master/README.txt

require 'rubygems'<br />
require 'right_aws'

# method overloads<br />
module RightAws<br />
  class AwsUtils #:nodoc:<br />
    def self.CGIescape(raw)<br />
      e = CGI::escape raw<br />
      e.gsub(/\+/, &quot;%20&quot;)<br />
    end

    def self.CGIunescape(escaped)<br />
      r = escaped.gsub(&quot;%20&quot;, &quot;+&quot;)<br />
      CGI::unescape r<br />
    end<br />
  end<br />
  class S3Interface<br />
    def get_link(bucket, key, expires=nil, headers={}, response_params={})<br />
      if response_params == {} || response_params == nil<br />
        generate_link('GET', headers.merge(:url=&gt;&quot;#{bucket}/#{CGI::escape key}&quot;), expires)<br />
      else<br />
        params_s = response_params.sort { |a,b| a[0] &lt;=&gt; b[0] }.map { |x|<br />
          if (x[0] == 'response-content-disposition')<br />
            if (x[1][/(.+filename=)(.+)/])<br />
              # escape the filename with &quot;+&quot; being replaced with &quot;%20&quot; to avoid enconding issue on non-ascii chars<br />
              x[1] = &quot;#{$1}#{AwsUtils.CGIescape($2)}&quot;<br />
            end<br />
          end<br />
          &quot;#{x[0]}=#{AwsUtils.CGIescape(x[1])}&quot; # collect escaped parameters<br />
        }.join('&amp;')<br />
        generate_link('GET', headers.merge(:url=&gt;&quot;#{bucket}/#{CGI::escape key}?#{params_s}&quot;), expires)<br />
      end<br />
    rescue<br />
      on_exception<br />
    end

    def canonical_string(method, path, headers={}, expires=nil) # :nodoc:<br />
      s3_headers = {}<br />
      headers.each do |key, value|<br />
        key = key.downcase<br />
        value = case<br />
                when value.is_a?(Array) then value.join('')<br />
                else                         value.to_s<br />
                end<br />
        s3_headers[key] = value.strip if key[/^#{AMAZON_HEADER_PREFIX}|^content-md5$|^content-type$|^date$/o]<br />
      end<br />
      s3_headers['content-type'] ||= ''<br />
      s3_headers['content-md5']  ||= ''<br />
      s3_headers['date']           = ''      if s3_headers.has_key? 'x-amz-date'<br />
      s3_headers['date']           = expires if expires<br />
        # prepare output string<br />
      out_string = &quot;#{method}\n&quot;<br />
      s3_headers.sort { |a, b| a[0] &lt;=&gt; b[0] }.each do |key, value|<br />
        out_string &lt;&lt; (key[/^#{AMAZON_HEADER_PREFIX}/o] ? &quot;#{key}:#{value}\n&quot; : &quot;#{value}\n&quot;)<br />
      end<br />
        # ignore everything after the question mark...<br />
      out_string &lt;&lt; path.gsub(/\?.*$/, '')<br />
       # ...unless there is an acl or torrent parameter<br />
      out_string &lt;&lt; '?acl'      if path[/[&amp;?]acl($|&amp;|=)/]<br />
      out_string &lt;&lt; '?torrent'  if path[/[&amp;?]torrent($|&amp;|=)/]<br />
      out_string &lt;&lt; '?location' if path[/[&amp;?]location($|&amp;|=)/]<br />
      out_string &lt;&lt; '?logging'  if path[/[&amp;?]logging($|&amp;|=)/]  # this one is beta, no support for now<br />
      if method == 'GET'<br />
        # fetch all response-* param pairs recursively (dirty method)<br />
        while path[/[&amp;?](response\-[A-Za-z\-]+=[^&amp;]+)($|&amp;)/]<br />
          resp = $1<br />
          # string-to-sign must be un-encoded, so an unescape process is taken on resp,<br />
          # which is already escaped in get_link()<br />
          out_string &lt;&lt; (&quot;#{out_string[/\?/] ? &quot;&amp;&quot; : &quot;?&quot;}#{AwsUtils.CGIunescape(resp)}&quot;)<br />
          path = path.gsub(/[&amp;?]#{resp}/, '')<br />
        end<br />
      end<br />
      out_string<br />
    end<br />
  end<br />
end

ACCESS_KEY_ID = 'chunked...'<br />
ACCESS_SECRET_KEY = 'chunked...'

s3instance = RightAws::S3Interface.new(ACCESS_KEY_ID, ACCESS_SECRET_KEY)

s3instance.get_link('bucket', &quot;key/to/song.mp3&quot;, nil, {}, {<br />
  &quot;response-expires&quot; =&gt; &quot;Tue, 01 Feb 2011 16:00:00 GMT&quot;,<br />
  &quot;response-content-disposition&quot; =&gt; &quot;attachment; filename=ma chanson préférée.mp3&quot;,<br />
  &quot;response-cache-control&quot;=&gt;&quot;No-cache&quot;,<br />
  &quot;response-content-type&quot; =&gt; &quot;audio/mp3&quot;,<br />
  &quot;response-content-language&quot; =&gt; &quot;zh-tw, en&quot;<br />
})<br />
[/sourcecode]

The last line generates the following Get Object link to the specified object, with <code>response-*</code> parameters: 

<pre>https://bucket.s3.amazonaws.com:443/key%2Fto%2Fsong.mp3
?response-cache-control=No-cache
&amp;response-content-disposition=attachment%3B%20filename%3Dma%2520chanson%2520pr%25C3%25A9f%25C3%25A9r%25C3%25A9e.mp3
&amp;response-content-language=zh-tw%2C%20en
&amp;response-content-type=audio%2Fmp3
&amp;response-expires=Tue%2C%2001%20Feb%202011%2016%3A00%3A00%20GMT
&amp;Signature=nPD...&amp;Expires=1296628484&amp;AWSAccessKeyId=AKIA...</pre>
