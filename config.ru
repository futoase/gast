#\ -s puma

require './lib/gast/app'

map '/assets' do
  run Gast::App.sprockets
end

map '/' do
  run Gast::App
end
