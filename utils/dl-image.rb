require "uri"

GLOB = File.expand_path("../_posts/**/*.md", __dir__)

MD = /!\[[^\]]*\]\((?<url>http[^\)]+)\)/
HTML = /<img src="(?<url>[^"]+)"?/i
REGEX = /#{MD}|#{HTML}/

FLICKR_URL = /^https?:\/\/.+flickr.com/

IMAGE_ROOT = File.expand_path("../images", __dir__)

FILENAME_PATTERN = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})-(?<slug>[^\.]+)/

IMAGE_DIR_TEMPLATE = "%{year}/%{dirname}"

def scan_img(content)
  content.scan(REGEX).flatten.compact
end

def extract_metadata(name)
  FILENAME_PATTERN.match(name)
end

Dir[GLOB].each do |path|
  basename = File.basename(path, ".md")
  metadata = extract_metadata(basename)

  images = []

  File.open(path) do |fin|
    images = scan_img(fin.read).reject {|url| url =~ FLICKR_URL }
  end

  next if images.empty?
  puts "# #{basename}"

  images.each do |image|
    path = URI.parse(image).path
    filename = path.split('/').last

    dir = sprintf(IMAGE_DIR_TEMPLATE, year: metadata[:year], dirname: basename)
    full_dir = File.join(IMAGE_ROOT, dir)

    puts image
    puts "  dir=#{full_dir}"
    puts "  out=#{filename}"
    puts
  end

  puts
end
