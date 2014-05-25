require 'spec_helper'

describe Gast::Memo do
  let(:welcome_to_underground) { 'Welcome to underground' }

  after(:each) do
    FileUtils.rm_r(Dir.glob(Gast::PATH + '/**'), secure: true)
  end

  it 'should be get list of directory' do
    10.times do |i|
      Gast::Memo.save(welcome_to_underground)
    end
    expect(Gast::Memo.number).to eq 10
  end

end
