module RailsSettingsUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "creates an initializer file at config/initializers/rails_settings_ui.rb and adds route to config/routes.rb"
      source_root File.expand_path('../../../..', __FILE__)

      def generate_initialization
        copy_file 'config/initializers/rails_settings_ui.rb', 'config/initializers/rails_settings_ui.rb'
      end

      def generate_routing
        route "mount RailsSettingsUi::Engine, at: 'settings'"
        log "# You can access RailsSettingsUi urls like this: rails_settings_ui_path #=> '/settings'"
      end
    end
  end
end