GLOB = File.expand_path("../_posts/**/*.md", __dir__)

MD = /!\[[^\]]*\]\((?<url>http[^\)]+)\)/
HTML = /<img src="(?<url>[^"]+)"?/i
REGEX = /#{MD}|#{HTML}/

FLICKR_URL = /^https?:\/\/.+flickr.com/

def scan_img(content)
  content.scan(REGEX).flatten.compact
end

Dir[GLOB].each do |path|
  File.open(path) do |fin|
    images = scan_img(fin.read).reject {|url| url =~ FLICKR_URL }

    next if images.empty?
    puts "\e[1;33m#{path}\e[m"

    images.each do |image|
      puts image
    end

    puts
  end
end
