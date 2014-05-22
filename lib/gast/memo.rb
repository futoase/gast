require 'gast'

module Gast

  class Memo

    def self.save(content, language="no-highlight")
      @repo = Gast::Repository.new
      @repo.content = CGI.unescapeHTML(content.to_s)
      @repo.language = CGI.unescapeHTML(language.to_s)
      @repo.publish
      @repo.commit!
      @repo.dir_name
    end

    def self.update(id, content, language="no-highlight")
      return id if content.to_s.chomp == item(id).chomp
      @repo = Gast::Repository.new(id)
      @repo.content = CGI.unescapeHTML(content.to_s)
      @repo.language = CGI.unescapeHTML(language.to_s)
      @repo.publish
      @repo.commit!
      @repo.dir_name
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

    def initialize; end

  end
end
