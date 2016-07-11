# Run the printed script with shell script
require "uri"
require_relative "./image-scan"
require_relative "./image-map"

def sanitize(string)
  string.gsub('/', '\/')
end

ImageScan.scan!.each_pair do |filename, data|
  puts "# #{filename}"

  data.images.each do |image|
    old_url = sanitize Regexp.escape image.url
    new_path = sanitize Regexp.escape ImageMap.new_relative_path(filename, data, image)

    puts %Q{sed -i '' -e "s/#{old_url}/#{new_path}/" #{data.path}}
  end

  puts
end
