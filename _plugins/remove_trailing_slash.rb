module Jekyll
  module RemoveTrailingSlash
    def remove_trailing_slash(input)
      input.sub(/\/$/,'')
    end
  end
end

Liquid::Template.register_filter(Jekyll::RemoveTrailingSlash)
