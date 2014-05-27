require 'gast'

module Gast
  class App < Gast::Base
    get '/' do
      haml :index, locals: { new_post: true }
    end

    get '/posts/list' do
      @lists = Gast::Memo.lists
      haml :list
    end

    get '/posts/view/:content_id' do
      @item = Gast::Memo.item(params[:content_id].to_s)
      @language = Gast::Memo.language(params[:content_id].to_s)
      @content_hash = params[:content_id].to_s
      haml :view
    end

    get '/posts/edit/:content_id' do
      @item = Gast::Memo.item(params[:content_id].to_s)
      @content_hash = params[:content_id].to_s
      haml :edit
    end

    put '/posts/update/:content_id' do
      @result = Gast::Memo.update(
        params[:content_id].to_s,
        params[:content].to_s,
        params[:language].to_s
      )
      redirect to("/posts/view/#{params[:content_id]}")
    end

    post '/posts/new' do
      results = Gast::Memo.save(
        params[:content].to_s,
        params[:language].to_s
      )
      redirect to("/posts/view/#{results[:content_id]}")
    end
  end
end
