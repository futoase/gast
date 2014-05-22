require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

$:.unshift File.realpath(File.dirname(__FILE__) + '/../lib')
require 'rspec'
require 'rack/test'
require 'webmock/rspec'

require 'sinatra'
require 'timecop'

disable :show_exceptions
disable :raise_errors

require 'gast/app'
require 'gast/memo'
require 'gast/repository'

include Rack::Test::Methods

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

def get_fixture(name)
  File.read(File.expand_path('./fixtures/' + name, __dir__))
end
