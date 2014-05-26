require 'gast'

module Gast
  class Repository
    attr_reader :path
    attr_writer :content, :language
    attr_accessor :dir_name

    def initialize; end

    def create
      @dir_name = new_name_of_repository if @dir_name.nil?
      @path = path_of_repository
      create_dir
      @git = Git.init(@path)
    end

    def publish
      save_content
      save_language
    end

    def remove!
      FileUtils.remove_entry_secure(@path)
    end

    def save!
      @git.add(all: true)
      @git.commit_all("commit: #{DateTime.now}")
    end

    def commit!
      return save! if @git.ls_files.length == 0
      return save! if @git.status.changed.length != 0
    end

    private

    def create_dir
      return unless File.exist?(@path)
      FileUtils.mkdir_p(@path)
      FileUtils.chmod(0755, @path)
    end

    def save_content
      path = File.expand_path(@path + '/content')
      open(path, 'w', 0644) do |io|
        io.flock(File::LOCK_EX)
        io.write(@content)
        io.flock(File::LOCK_UN)
      end
    end

    def save_language
      path = File.expand_path(@path + '/language')
      open(path, 'w', 0644) do |io|
        io.flock(File::LOCK_EX)
        io.write(@language)
        io.flock(File::LOCK_UN)
      end
    end

    def new_name_of_repository
      Digest::SHA512.new.update(rand.to_s).to_s[0..30]
    end

    def path_of_repository
      File.expand_path(File.join(Gast::PATH, @dir_name))
    end
  end
end
