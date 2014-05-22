require 'cgi'

module Gast
  class Post
    def initalize(content)
      @content = content
    end

    def view
      CGI.escapeHTML(@content)
    end
  end
end
