require 'spec_helper'

describe Gast::Memo do

  def repo_path(num)
    File.expand_path("/tmp/gast/#{num}")
  end

  def repo_dir
    '/tmp/gast'
  end

  let(:welcome_to_underground) { "Welcome to underground" }

  after(:each) {
    FileUtils.rm_r(Dir.glob(repo_dir + '/**'), secure: true)
  }

  it "should be get list of directory" do
    0.upto(9) do |i|
      Gast::Memo.save(welcome_to_underground)
    end
    expect(Gast::Memo.number).to eq 10
  end

end
