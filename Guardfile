# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :spork, :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('lib/gast.rb')
  watch(%r{^lib/gast/(.+)\.rb$})
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
end

guard :rspec, cmd: 'bundle ex rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{spec/feature/.+.rb$})

  watch(%r{^lib/gast/app.rb$})                        { |m| "spec/controller_spec.rb" }
  watch(%r{^lib/gast/(.+)\.rb$})                      { |m| "spec/#{m[1]}_spec.rb" }
end

