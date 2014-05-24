require 'gast'

module Gast
  class App < Sinatra::Base

    enable :method_override
    set :sprockets, Sprockets::Environment.new(root)
    set :assets_prefix, '/assets'
    set :digest_assets, false
    set :views, settings.root + '/templates'

    configure do
      sprockets.append_path File.join(root, 'assets', 'stylesheets')
      sprockets.append_path File.join(root, 'assets', 'javascripts')
      sprockets.append_path File.join(root, 'assets', 'images')

      Sprockets::Helpers.configure do |config|
        config.environment = sprockets
        config.prefix      = assets_prefix
        config.digest      = digest_assets
        config.public_path = '/public'

        config.debug       = true 
      end

      register Sinatra::Reloader
    end

    helpers do
      include Sprockets::Helpers
    end

    before %r{/posts/\w+/(\w+)} do |id|
      unless /[a-zA-Z0-9]{30}/ =~ id.to_s
        halt haml(:error, locals: { message: "error is format of id" })
      end
    end

    not_found do
      haml :not_found
    end
    
    error do
      haml :error
    end

    get '/' do
      haml :index, locals: { new_post: true }
    end

    get '/posts/list' do
      @lists = Gast::Memo.lists
      haml :list
    end

    get '/posts/view/:id' do
      @item = Gast::Memo.item(params[:id].to_s)
      @language = Gast::Memo.language(params[:id].to_s)
      @content_hash = params[:id].to_s
      haml :view
    end

    get '/posts/edit/:id' do
      @item = Gast::Memo.item(params[:id].to_s)
      @content_hash = params[:id].to_s
      haml :edit
    end

    put '/posts/update/:id' do
      @result = Gast::Memo.update(
        id=params[:id].to_s, 
        content=params[:content].to_s,
        language=params[:language].to_s
      )
      redirect to("/posts/view/#{params[:id]}")
    end

    post '/posts/new' do
      results = Gast::Memo.save(
        params[:content].to_s, params[:language].to_s
      )
      redirect to("/posts/view/#{results[:id]}")
    end

  end
end
