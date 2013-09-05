require File.expand_path("../lib/rails-settings-ui/version", __FILE__)


Gem::Specification.new do |s|
  s.name = "rails-settings-ui"
  s.author = 'Andrey Morkosv'
  s.email = 'accessd0@gmail.com'
  s.homepage = 'https://github.com/accessd/rails-settings-ui'
  s.license = 'MIT'

  s.summary = "User interface for manage settings (rails engine)"
  s.description = "User interface for manage settings with rails-settings-cached gem"


  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "i18n"
  s.add_dependency "haml-rails"
  s.add_dependency "twitter-bootstrap-rails"
  s.add_dependency "rails-settings-cached", "=0.3.1"

  s.version = RailsSettingsUi::VERSION
end
