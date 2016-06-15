GLOB = File.expand_path("../_posts/**/*.md", __dir__)
MATCHER = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})-(?<title>.+)\.md/

def make_redirector(data)
  "redirect_from: /posts/#{data[:year]}/#{data[:month]}/#{data[:day]}/#{data[:title]}"
end

Dir[GLOB].each do |path|
  filename = File.basename(path)
  matchdata = MATCHER.match(filename)
  content = File.read(path)
  redirector = make_redirector(matchdata)

  puts filename

  content = content.sub("comments:", "#{redirector}\ncomments:")
  File.open(path, "w") do |fout|
    fout.write content
  end
end
