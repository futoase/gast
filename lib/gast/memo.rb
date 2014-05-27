require 'gast'

module Gast
  class Memo
    def self.save(content, language = 'no-highlight')
      @repo = Gast::Repository.new
      @repo.create
      @repo.content = CGI.unescapeHTML(content.to_s)
      @repo.language = CGI.unescapeHTML(language.to_s)
      @repo.write
      @repo.commit!
      {
        content_id: @repo.dir_name,
        language: language
      }
    end

    def self.update(content_id, content, language = 'no-highlight')
      return content_id if content.to_s.chomp == item(content_id).chomp
      @repo = Gast::Repository.new
      @repo.dir_name = content_id
      @repo.create
      @repo.content = CGI.unescapeHTML(content.to_s)
      @repo.language = CGI.unescapeHTML(language.to_s)
      @repo.write
      @repo.commit!
      {
        content_id: @repo.dir_name,
        language: language
      }
    end

    def self.number
      lists.length
    end

    def self.lists
      Dir.glob(File.expand_path(Gast::PATH + '/**')).map do |dir|
        dir.split('/').last
      end
    end

    def self.item(id)
      CGI.escapeHTML(
        File.read(File.expand_path(Gast::PATH + "/#{id}/content"))
      )
    end

    def self.language(id)
      CGI.escapeHTML(
        File.read(File.expand_path(Gast::PATH + "/#{id}/language"))
      )
    end

    def initialize; end
  end
end
