require "pathname"

ROOT = Pathname.new(File.expand_path("..", __dir__))
IMAGE_ROOT = File.expand_path("../images", __dir__)
IMAGE_DIR_TEMPLATE = "%{year}/%{dirname}"

class ImageMap
  def self.new_dir(basename, data)
    dir = sprintf(IMAGE_DIR_TEMPLATE, year: data.year, dirname: basename)
    full_dir = File.join(IMAGE_ROOT, dir)

    return full_dir
  end

  def self.new_relative_path(basename, data, image)
    relative = Pathname.new(File.join(new_dir(basename, data), image.filename)).relative_path_from(ROOT).to_s

    "/#{relative}"
  end
end
