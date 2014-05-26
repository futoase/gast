require 'spec_helper'

def app
  Gast::App
end

describe Gast::App do

  after(:each) do
    FileUtils.rm_r(Dir.glob(Gast::PATH + '/**'), secure: true)
  end

  let(:hello_world) { 'Hello World' }
  let(:welcome_to_underground) { 'Welcome to underground' }
  let(:inline_html) { "<script>alert('Hello world!');</script>" }
  let(:sample_of_code_ruby) { get_fixture('sample_of_code.rb') }

  let(:view_path) { %r{.+/posts/view/[a-z0-9]+} }

  it 'should be get index' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'should be get title of index' do
    get '/'
    expect(last_response.body).to match(/Gast/)
  end

  it 'should be get error' do
    get '/hogehoge'
    expect(last_response).not_to be_ok
  end

  it 'should be get list' do
    get '/posts/list'
    expect(last_response).to be_ok
  end

  it 'should be save of content on git directory' do
    post('/posts/new', content: hello_world)
    expect(last_response.status).to eq 302
    expect(last_response.location).to match(view_path)
  end

  it 'should be update content' do
    post('/posts/new', content: hello_world)

    expect(last_response.status).to eq 302
    expect(last_response.location).to match(view_path)

    post('/posts/new', content: welcome_to_underground)
    expect(last_response.status).to eq 302
    expect(last_response.location).to match(view_path)
  end

  it 'should be view of item' do
    post('/posts/new', content: hello_world)

    get "/posts/view/#{dir_name_of_latest_repository}"

    expect(last_response).to be_ok
    expect(latest_content).to eq hello_world
  end

  it 'should be can update of item' do
    post('/posts/new', content: hello_world)

    get "/posts/view/#{dir_name_of_latest_repository}"

    expect(last_response).to be_ok

    put("/posts/update/#{dir_name_of_latest_repository}",
        content: welcome_to_underground)
    get "/posts/view/#{dir_name_of_latest_repository}"

    expect(last_response).to be_ok

    expect(latest_content).to eq welcome_to_underground
  end

  it 'should be get not found' do
    get '/posts/hoge'

    expect(last_response).not_to be_ok
    expect(last_response.status).to be 404
    expect(last_response.body).to match(/Not Found/)
  end

  it 'should be get content is escaped by HTML' do
    post('/posts/new', content: inline_html)

    expect(latest_content).to eq inline_html

    get "/posts/view/#{dir_name_of_latest_repository}"

    expect(last_response).to be_ok
    expect(last_response.body).to include(CGI.escapeHTML(inline_html))
  end

  it 'should be post language type the code highlight' do
    post('/posts/new', content: sample_of_code_ruby, language: 'ruby')

    expect(latest_content).to eq sample_of_code_ruby
    expect(latest_language_of_content).to eq 'ruby'

    get "/posts/view/#{dir_name_of_latest_repository}"

    expect(last_response).to be_ok
  end

  it 'should be succeeded change of language type' do
    post('/posts/new', content: sample_of_code_ruby, language: 'ruby')

    expect(latest_content).to eq sample_of_code_ruby
    expect(latest_language_of_content).to eq 'ruby'

    put("/posts/update/#{dir_name_of_latest_repository}",
        content: sample_of_code_ruby, language: 'python')

    expect(latest_content).to eq sample_of_code_ruby
    expect(latest_language_of_content).to eq 'python'
  end

end
