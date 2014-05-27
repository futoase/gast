require 'gast'

module Gast
  class Base < Sinatra::Base
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
    end

    before %r{/posts/\w+/(\w+)} do |id|
      unless /[a-zA-Z0-9]{30}/ =~ id.to_s
        halt haml(:error, locals: { message: 'error is format of id' })
      end
    end

    not_found do
      haml :not_found
    end

    error do
      haml :error
    end
  end
end
