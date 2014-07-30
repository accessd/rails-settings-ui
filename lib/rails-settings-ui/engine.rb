require 'haml-rails'
require 'sass'
require 'sass-rails'
require 'bootstrap-sass'

module ::RailsSettingsUi
  class Engine < Rails::Engine
    isolate_namespace RailsSettingsUi

    initializer "assets_precompile" do |app|
      app.config.assets.precompile += %w( glyphicons-halflings.png glyphicons-halflings-white.png)
    end

    config.generators do |g|
      g.test_framework      :rspec,        fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
