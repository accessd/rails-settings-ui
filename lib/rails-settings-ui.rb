# encoding: utf-8
require 'rails-settings-ui/engine'
require 'rails-settings-ui/main_app_route_delegator'
require 'rails-settings-ui/version'

require "rails-settings-ui/type_converter"

module RailsSettingsUi
  mattr_accessor :parent_controller
  self.parent_controller = '::ApplicationController'

  # Settings not displayed in the interface (eg. [:launch_mode, :project_name])
  mattr_accessor :ignored_settings
  self.ignored_settings = []

  # Settings displayed in the interface as select tag instead checkboxes (useful for array with one possible choice)
  mattr_accessor :settings_displayed_as_select_tag
  self.settings_displayed_as_select_tag = []

  mattr_accessor :settings_class
  self.settings_class = "Settings"

  class << self
    def inline_main_app_routes!
      ::RailsSettingsUi::ApplicationController.helper ::RailsSettingsUi::MainAppRouteDelegator
    end

    def setup
      yield self
    end

    def settings_klass
      settings_class.constantize
    end
  end
end
