require 'spec_helper'

describe Gast::Repository do

  let(:repo) { Gast::Repository.new }

  let(:git) { Git.init(repo.path) }

  let(:repo_path) { File.expand_path("/tmp/gast/1") }

  let(:repo_dir) { "/tmp/gast" }

  let(:user_content) { "Hello World" }
  let(:selected_language) { "ruby" }

  before(:each) {
    repo.content = user_content
    repo.language = selected_language
    repo.publish
    repo.commit!
  }

  after(:each) {
    FileUtils.rm_r(Dir.glob(repo_dir + '/**'), secure: true)
  }

  it "should be create of repository" do
    expect(FileTest.exists?(repo.path)).to be_true
  end

  it "should be content is a Hello world" do
    expect(File.read(repo.path + '/content')).to eq user_content
  end

  it "should be language is a ruby" do
    expect(File.read(repo.path + '/language')).to eq selected_language
  end

  it "should be save of commit message is correct" do
    Timecop.freeze
    expect(git.log.first.message).to eq "commit: #{DateTime.now.to_s}"
    Timecop.return
  end

end
