require "ostruct"
require "uri"

class ImageScan
  GLOB = File.expand_path("../_posts/**/*.md", __dir__)

  MD = /!\[[^\]]*\]\((?<url>http[^\)]+)\)/
  HTML = /<img src="(?<url>[^"]+)"?/i
  REGEX = /#{MD}|#{HTML}/

  FLICKR_URL = /^https?:\/\/.+flickr.com/

  FILENAME_PATTERN = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})-(?<slug>[^\.]+)/

  def self.scan!
    index = {}

    Dir[GLOB].each do |path|
      urls = scan_file(path)
      next if urls.empty?

      basename = File.basename(path, ".md")
      metadata = extract_metadata(basename)

      images = urls.map do |url|
        img_filename = URI.parse(url).path.split('/').last

        OpenStruct.new({
          filename: img_filename,
          url: url
        })
      end

      index[basename] = OpenStruct.new({
        path: path,
        year: metadata[:year],
        month: metadata[:month],
        day: metadata[:day],
        slug: metadata[:slug],
        images: images
      })
    end

    index
  end

  private
  def self.scan_file(path)
    images = []

    File.open(path) do |fin|
      images = scan_content(fin.read).reject {|url| url =~ FLICKR_URL }
    end

    images
  end

  def self.scan_content(content)
    content.scan(REGEX).flatten.compact
  end

  def self.extract_metadata(name)
    FILENAME_PATTERN.match(name)
  end
end
