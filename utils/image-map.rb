IMAGE_ROOT = File.expand_path("../images", __dir__)
IMAGE_DIR_TEMPLATE = "%{year}/%{dirname}"

class ImageMap
  def self.new_dir(basename, data)
    dir = sprintf(IMAGE_DIR_TEMPLATE, year: data.year, dirname: basename)
    full_dir = File.join(IMAGE_ROOT, dir)

    return full_dir
  end
end
