require File.expand_path('../lib/rails-settings-ui/version', __FILE__)


Gem::Specification.new do |s|
  s.name = 'rails-settings-ui'
  s.author = 'Andrey Morskov'
  s.email = 'accessd0@gmail.com'
  s.homepage = 'https://github.com/accessd/rails-settings-ui'
  s.license = 'MIT'

  s.summary = 'User interface for manage settings (rails engine)'
  s.description = 'User interface for manage settings with rails-settings gem'


  s.files = Dir['{app,lib,config}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.md']

  s.add_dependency 'rails', '>= 3.0'
  s.add_dependency 'i18n'
  s.add_dependency 'haml-rails'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'bootstrap-sass', '>= 3.1.1'
  s.add_development_dependency 'rspec-rails', '>= 3.0.1'
  s.add_development_dependency 'capybara', '~> 2.4.1'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'factory_girl_rails'
  s.test_files = Dir['spec/**/*']

  s.version = RailsSettingsUi::VERSION
end
