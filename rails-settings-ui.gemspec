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
  s.add_dependency 'rails-settings-cached', '>= 2.0.0'
  s.add_dependency 'i18n'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'puma', '~> 4.3'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
  s.test_files = Dir['spec/**/*']

  s.version = RailsSettingsUi::VERSION
end
