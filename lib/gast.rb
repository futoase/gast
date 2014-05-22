require 'digest/sha2'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sprockets'
require 'sprockets-helpers'
require 'gast/memo'
require 'gast/app'
require 'gast/repository'
require 'haml'
require 'sass'
require 'git'
require 'cgi'

module Gast
  PATH = '/tmp/gast'
end
