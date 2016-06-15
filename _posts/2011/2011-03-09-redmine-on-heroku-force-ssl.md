---
layout: post
title: "讓部署在 Heroku 的 Redmine 強制使用 SSL"
published: true
date: 2011-03-09 00:00
tags: []
categories: []
comments: true

---

前一篇「<a href="http://blog.yorkxin.org/2011/03/08/redmine-1-1-on-heroku/">在 Heroku 安裝 Redmine (1.1-stable)</a>」僅是將 Redmine 給部署到 Heroku，不過，本人<del>因為金牛座天生的鑽牛角尖，</del>連這種專案管理系統也要求全站 HTTPS。所以寫一篇來記載步驟。
<h1>一、啟用 SSL 通訊協定</h1>
首先當然是去開通 Heroku 的 <a href="http://addons.heroku.com/ssl" target="_blank">SSL Add-on</a>，我只選免費的 Piggyback ，缺點是只能套用在屬於 <code>*.heroku.com</code> 的域名（ i.e. 預設的網址），如果 app 使用<a href="http://addons.heroku.com/custom_domains" target="_blank">自訂域名</a>，又想讓該自訂域名具有 SSL 話，得要使用有付款的方案。

<!--more-->

附帶一提，如果你跟我一樣，從未使用過 Add-on，則 Heroku 會要求你認證帳號（verify account），具體來說就是填信用卡資料及帳單位址，以後安裝其他需要租金的 Add-on 才可以正常付款。

<a href="http://addons.heroku.com/ssl"><img class="alignnone size-full wp-image-1203" title="heroku-piggyback-ssl" src="http://chitsaou.files.wordpress.com/2011/03/heroku-piggyback-ssl.png" alt="" width="640" height="307" /></a>

按一下 Add 以後，選擇要套用的 app ，就完成了；或是你直接在該 app 的 local repository 輸入指令：
<blockquote><code>heroku addons:add ssl:piggyback</code></blockquote>
<a href="http://chitsaou.files.wordpress.com/2011/03/heroku-ssl-select-app-to-apply.png"><img class="alignnone size-full wp-image-1204" title="heroku-ssl-select-app-to-apply" src="http://chitsaou.files.wordpress.com/2011/03/heroku-ssl-select-app-to-apply.png" alt="" width="364" height="281" /></a>

安裝完成後，你就可以透過 <code>https://</code> 的通訊協定訪問 Redmine。

不過這樣（對我來說）還不夠，事實上它依然可以透過 http:// 未加密通訊協定來訪問。這並不是我要的。所以接下來是如何強制使用 SSL。
<h1>二、讓 Redmine 使用 HTTPS （表面上）</h1>
在 Redmine 的網站設定中（Administration → Settings → General），有標題為 <strong>Protocol</strong> 的設定。不過它似乎並不會強制網站使用 HTTPS，而只是產生網址給外人時（例如發 email）所使用的 Protocol，它的上方有 Host name and path 的設定，也是同樣的用途。

不過因為接下來會修改到程式碼，來讓網站嚴格檢查通訊協定，修改後的程式會檢查這個設定，所以這裡可以先改為 HTTPS。

<a href="http://chitsaou.files.wordpress.com/2011/03/redmine-protocol.png"><img class="alignnone size-full wp-image-1205" title="redmine-protocol" src="http://chitsaou.files.wordpress.com/2011/03/redmine-protocol.png" alt="" width="396" height="231" /></a>

<span style="color:#000000;font-size:31px;line-height:46px;">三、讓 Redmine 嚴格檢查通訊協定</span>

為了讓 Redmine 可以嚴格檢查通訊協定，使 HTTPS 的網站不會透過 HTTP 訪問，這裡必須要改程式碼，當然， Git 就派上用場了。

修改 <code>app/controllers/application_controller.rb</code> ，在 <code>class</code> definition 裡面加上一個新的 <code>before_filter</code>（等下會再 <code>def</code> 它的內容）

[sourcecode language="ruby"]<br />
   include Redmine::I18n<br />
   before_filter :ensure_protocol # 新增這一行<br />
[/sourcecode]

接著，在 <code>ApplicationController</code> 的 private method 中加入 <code>ensure_protocol</code> 這一個 method，也就是剛剛寫的 <code>before_filter :ensure_protocol</code> 的內容。

[sourcecode language="ruby"]<br />
  # A modified global SSL checking<br />
  # src: https://github.com/retr0h/ssl_requirement<br />
  def ensure_protocol<br />
    ssl_required = 'https' == Setting[&quot;protocol&quot;] ? true : false

    if ssl_required &amp;&amp; !request.ssl?<br />
      redirect_to &quot;https://&quot; + request.host + request.request_uri<br />
      flash.keep<br />
      return false<br />
    elsif request.ssl? &amp;&amp; !ssl_required<br />
      redirect_to &quot;http://&quot; + request.host + request.request_uri<br />
      flash.keep<br />
      return false<br />
    end<br />
  end<br />
[/sourcecode]

其實這是從 <code><a href="https://github.com/retr0h/ssl_requirement" target="_blank">ssl_requirement</a></code> 這個 Rails Plugin 改來的，因為 <code>ssl_requirement</code> 要根據 action 去設定，我要的是整個網站，所以我就改成只有一個 filter 了。

程式碼中的 <code>Setting["protocol"]</code> 就是去檢查 Redmine 的 Protocol 這個設定值

寫好以後，commit 這個 chageset，然後部署到 Heroku ：
<blockquote><code>git commit -m 'explicit protocol checking'<br />
git push heroku master</code></blockquote>
此後，再用瀏覽器去開 Redmine ，你會發現它自動轉向正確的 Protocol 了。
