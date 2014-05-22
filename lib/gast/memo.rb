require 'gast'

module Gast

  class Memo

    def self.save(content)
      @repo = Gast::Repository.new
      @repo.content = CGI.unescapeHTML(content.to_s)
      @repo.publish
      @repo.commit!
      @repo.dir_name
    end

    def self.update(id, content)
      @repo = Gast::Repository.new(id)
      @repo.content = CGI.unescapeHTML(content.to_s)
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
