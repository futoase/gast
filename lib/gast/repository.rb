require 'gast'

module Gast
  class Repository

    attr_reader :path, :dir_name

    def initialize(dir_name=nil)
      if dir_name.nil?
        @dir_name = Digest::SHA512.new.update(rand.to_s).to_s[0..30]
      else
        @dir_name = dir_name.to_s
      end

      @path = File.expand_path(File.join(Gast::PATH, @dir_name))

      create_dir

      @git = Git.init(@path)
    end

    def content=(content)
      @content = content
    end

    def language=(language)
      @language = language.to_s
    end

    def publish
      @content_path = File.expand_path(@path + '/content')
      open(@content_path, 'w', 0644) { |io| io.write(@content) }

      @language_path = File.expand_path(@path + '/language')
      open(@language_path, 'w', 0644) { |io| io.write(@language) }
    end

    def remove!
      FileUtils.remove_entry_secure(@path)
    end

    def save!
      @git.add(all: true)
      @git.commit_all("commit: #{DateTime.now.to_s}")
    end

    def commit!
      return save! if @git.ls_files.length == 0
      return save! if @git.status.changed.length != 0
    end

    private

    def create_dir
      unless File.exists?(@path)
        FileUtils.mkdir_p(@path)
        FileUtils.chmod(0755, @path)
      end
    end

  end

end
