require 'gast'

module Gast
  module Memo
    extend Helper

    class Response
      attr_reader :content_id, :language, :content

      def initialize(content_id, language, content)
        @content_id = content_id
        @language = language
        @content = content
      end
    end

    class Request
      attr_reader :content_id, :language, :content

      def initialize(content_id, language, content)
        @content_id = content_id
        @language = language
        @content = content
      end
    end

    def response(content_id, language, content)
      Response.new(content_id, language, content)
    end
    module_function :response

    def request(content_id, language, content)
      Request.new(content_id, language, content)
    end
    module_function :request

    def repository(content, language, content_id = nil)
      repo = Repository.new
      repo.dir_name = content_id
      repo.create
      repo.content = unescape_html { content }
      repo.language = unescape_html { language }
      repo.write
      repo.commit!

      repo.dir_name
    end

    def create(content, language = DEFAULT_HIGHLIGHT)
      content_id = repository(content, language)
      response(content_id, language, content)
    end
    module_function :create

    def update(content_id, content, language = DEFAULT_HIGHLIGHT)
      content_id = repository(content, language, content_id)
      response(content_id, language, content)
    end
    module_function :update

    def changed?(content_id, content)
      content.to_s.chomp != item(content_id).chomp
    end
    module_function :changed?

    def number
      lists.length
    end
    module_function :number

    def lists
      Dir.glob(File.expand_path(Gast::PATH + '/**')).map do |dir|
        {
          content_id: dir.split('/').last,
          updated_at: File.stat(dir + '/content').mtime
        }
      end
    end
    module_function :lists

    def item(id)
      escape_html { get_content(id) }
    end
    module_function :item

    def log(id)
      repo = Repository.new
      repo.dir_name = id
      repo.log
    end

    def language(id)
      escape_html { get_language(id) }
    end
    module_function :language

    extend Memo
  end
end
