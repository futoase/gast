# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gast/version'

Gem::Specification.new do |spec|
  spec.name          = "gast"
  spec.version       = Gast::VERSION
  spec.authors       = ["futoase"]
  spec.email         = ["futoase@gmail.com"]
  spec.summary       = %q{memo application of using git}
  spec.description   = %q{memo application of using git}
  spec.homepage      = "https://github.com/futoase/gast"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.6"
  spec.add_dependency "rake"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "puma"
  spec.add_dependency "sequel"
  spec.add_dependency "haml"
  spec.add_dependency "sass"
  spec.add_dependency "git"
  spec.add_dependency "sprockets"
  spec.add_dependency "sprockets-helpers"

  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "capybara"
end
