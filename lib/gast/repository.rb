require 'gast'

module Gast
  class Repository
    attr_reader :path
    attr_writer :content, :language
    attr_accessor :dir_name

    def initialize; end

    def create
      new_name_of_repository
      path_of_repository
      create_dir
      setup_repository
    end

    def write
      write_content
      write_language
    end

    def log
      path_of_repository
      open_reposigory
      commit_log
    end

    def remove!
      FileUtils.remove_entry_secure(@path)
    end

    def save!
      commit_all
    end

    def commit!
      return save! unless changed_of_contents?
    end

    private

    def create_dir
      return unless File.exist?(@path)
      FileUtils.mkdir_p(@path)
      FileUtils.chmod(0755, @path)
    end

    def write_content
      path = File.expand_path(@path + '/content')
      open(path, 'w', 0644) do |io|
        io.flock(File::LOCK_EX)
        io.write(@content)
        io.flock(File::LOCK_UN)
      end
    end

    def write_language
      path = File.expand_path(@path + '/language')
      open(path, 'w', 0644) do |io|
        io.flock(File::LOCK_EX)
        io.write(@language)
        io.flock(File::LOCK_UN)
      end
    end

    def new_name_of_repository
      if @dir_name.nil?
        @dir_name = Digest::SHA512.new.update(rand.to_s).to_s[0..30]
      end
    end

    def path_of_repository
      @path = File.expand_path(File.join(Gast::PATH, @dir_name))
    end

    def setup_repository
      @git = Git.init(@path)
    end

    def open_reposigory
      @git = Git.open(@path)
    end

    def commit_log
      @git.log.map do |g|
        { sha: g.sha, time: g.date.to_s }
      end
    end

    def changed_of_contents?
      return false if @git.ls_files.length == 0
      return false if @git.status.changed.length != 0
      return true
    end

    def commit_all
      @git.add(all: true)
      @git.commit_all("commit: #{DateTime.now}")
    end
  end
end
