require 'gast'

module Gast
  module Helper
    def escape_html
      CGI.escapeHTML(yield.to_s) if block_given?
    end

    def unescape_html
      CGI.unescapeHTML(yield.to_s) if block_given?
    end

    def get_content(id)
      File.read(File.expand_path(Gast::PATH + "/#{id}/content"))
    end

    def get_content_dir(id)
      File.expand_path(Gast::PATH + "/#{id}")
    end

    def get_language(id)
      File.read(File.expand_path(Gast::PATH + "/#{id}/language"))
    end

    def get_title(id)
      path = File.expand_path(Gast::PATH + "/#{id}/title")
      File.exists?(path) ? File.read(path) : nil
    end
  end
end
