require 'gast'

module Gast
  class Base < Sinatra::Base
    register Sinatra::Namespace
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

    before do
      @languages = Gast::LANGUAGES
      @content_id = params[:content_id].to_s
    end

    not_found do
      haml :not_found
    end

    error do
      haml :error
    end

    namespace '/posts' do
      before %r{/\w+/(\w+)} do |id|
        unless /[a-zA-Z0-9]{30}/ =~ id.to_s
          halt haml(:error, locals: {
            message: 'error is format of id'
        })
        end
      end

      before '/new' do
        @content  = params[:content].to_s
        @language = params[:language].to_s
        @title    = params[:title].to_s

        if @content.length == 0
          halt haml(:error, locals: {
            message: 'require of content!'
          })
        end

        result = Gast::Memo.create(@content, @language, @title)
        @content_id = result.content_id
      end

      before '/list' do
        @lists = Gast::Memo.lists
      end

      before '/*/:content_id' do
        if %w[view log edit update].include? request.path_info.split('/')[2]
          @content_id = params[:content_id].to_s
          @content    = params[:content].to_s
          @language   = params[:language].to_s
          @title      = params[:title].to_s
        end
      end

      before '/view/:content_id' do
        @item     = Gast::Memo.item(@content_id)
        @language = Gast::Memo.language(@content_id)
        @title    = Gast::Memo.title(@content_id)
      end

      before '/log/:content_id' do
        @log = Gast::Memo.log(@content_id)
      end

      before '/edit/:content_id' do
        @item     = Gast::Memo.item(@content_id)
        @language = Gast::Memo.language(@content_id)
        @title    = Gast::Memo.title(@content_id)
      end

      before '/update/:content_id' do
        if Gast::Memo.changed?(@content_id, @content, @language, @title)
          Gast::Memo.update(@content_id, @content, @language, @title)
        end
      end
    end
  end
end
