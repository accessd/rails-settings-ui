# encoding: utf-8
require 'rails-settings-ui/engine'
require 'rails-settings-ui/main_app_route_delegator'
require 'rails-settings-ui/version'

require 'rails-settings-cached'

module RailsSettingsUi
  mattr_accessor :parent_controller
  self.parent_controller = '::ApplicationController'

  # Settings not displayed in the interface (eg. [:launch_mode, :project_name])
  mattr_accessor :ignored_settings
  self.ignored_settings = []

  class << self
    def inline_main_app_routes!
      ::RailsSettingsUi::ApplicationController.helper ::RailsSettingsUi::MainAppRouteDelegator
    end

    def setup
      yield self
    end
  end
end
