require 'gast'

module Gast

  class Memo

    def self.save(content)
      @repo = Gast::Repository.new
      @repo.content = content.to_s
      @repo.publish
      @repo.commit!
      @repo.dir_name
    end

    def self.update(id, content)
      return id if content.to_s.chomp == item(id).chomp
      @repo = Gast::Repository.new(id)
      @repo.content = content.to_s
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
      File.read(File.expand_path(Gast::PATH + "/#{id}/content"))
    end

    def initialize; end

  end
end
