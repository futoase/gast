require 'spec_helper'

describe Gast::Memo do
  let(:welcome_to_underground) { 'Welcome to underground' }

  after(:each) { cleanup_in_the_dir }

  it 'should be get list of directory' do
    10.times do |i|
      Gast::Memo.create(welcome_to_underground)
    end
    expect(Gast::Memo.number).to eq 10
  end

  it 'should be get mtime of file in the list' do
    Gast::Memo.create(welcome_to_underground)

    get '/posts/list'
    expect(last_response).to be_ok
  end
end
