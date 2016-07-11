# Run the printed script with `aria2c -i urls.txt`
require "uri"
require_relative "./image-scan"
require_relative "./image-map"

ImageScan.scan!.each_pair do |basename, data|
  puts "# #{basename}"

  data.images.each do |image|
    puts image.url
    puts "  dir=#{ImageMap.new_dir(basename, data)}"
    puts "  out=#{image.filename}"
    puts
  end

  puts
end
