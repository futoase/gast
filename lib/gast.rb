require 'digest/sha2'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/contrib'
require 'sinatra/namespace'
require 'sprockets'
require 'sprockets-helpers'
require 'gast/helper'
require 'gast/memo'
require 'gast/app'
require 'gast/repository'
require 'gast/base'
require 'haml'
require 'sass'
require 'git'
require 'cgi'
require 'yaml'

module Gast
  setting_of_path = YAML.load_file(
    File.expand_path('../config/path.yml', __dir__)
  )
  
  PATH = setting_of_path['save_dir']

  LANGUAGES = YAML.load_file(
    File.expand_path('../config/languages.yml', __dir__)
  )

  DEFAULT_HIGHLIGHT = 'no-highlight'
end
