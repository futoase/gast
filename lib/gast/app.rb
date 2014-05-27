require 'gast'

module Gast
  class App < Gast::Base
    get '/' do
      haml :index, locals: { new_post: true }
    end

    namespace '/posts' do
      get '/list' do
        haml :list
      end

      get '/view/:content_id' do
        haml :view
      end

      get '/edit/:content_id' do
        haml :edit
      end

      put '/update/:content_id' do
        redirect to("/posts/view/#{@content_id}")
      end

      post '/new' do
        redirect to("/posts/view/#{@content_id}")
      end
    end
  end
end
