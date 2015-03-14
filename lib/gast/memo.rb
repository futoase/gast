require 'gast'

module Gast
  module Memo
    extend Helper

    class Response
      attr_reader :content_id, :language, :content, :title

      def initialize(content_id, language, content, title)
        @content_id = content_id
        @language   = language
        @content    = content
        @title      = title
      end
    end

    class Request
      attr_reader :content_id, :language, :content, :title

      def initialize(content_id, language, content, title)
        @content_id = content_id
        @language   = language
        @content    = content
        @title      = title
      end
    end

    def response(content_id, language, content, title)
      Response.new(content_id, language, content, title)
    end
    module_function :response

    def request(content_id, language, content, title)
      Request.new(content_id, language, content, title)
    end
    module_function :request

    def repository(content, language, content_id = nil, title)
      repo = Repository.new
      repo.dir_name = content_id
      repo.create
      repo.content = unescape_html { content }
      repo.language = unescape_html { language }
      if title
        repo.title = unescape_html { title }
      end
      repo.write
      repo.commit!

      repo.dir_name
    end

    def create(content, language = DEFAULT_HIGHLIGHT, title = nil)
      content_id = repository(content, language, nil, title)
      response(content_id, language, content, title)
    end
    module_function :create

    def update(content_id, content, language = DEFAULT_HIGHLIGHT, title = nil)
      content_id = repository(content, language, content_id, title)
      response(content_id, language, content, title)
    end
    module_function :update

    def changed?(content_id, content, language, title)
      content.to_s.chomp  != item(content_id).chomp     ||
      language.to_s.chomp != language(content_id).chomp ||
      title.to_s.chomp    != title(content_id).chomp
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
          title:      File.exist?(dir + '/title') ? File.open(dir + '/title').read : nil,
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

    def title(id)
      escape_html { get_title(id) }
    end
    module_function :language

    extend Memo
  end
end
