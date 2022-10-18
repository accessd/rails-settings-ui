# encoding: utf-8
require 'rails-settings-ui/engine'
require 'rails-settings-ui/route_delegator'
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

  mattr_accessor :defaults_for_settings
  self.defaults_for_settings = {}

  mattr_accessor :engine_name
  self.engine_name = "main_app"

  class << self
    def inline_main_app_routes!
      warn("[DEPRECATION] inline_main_app_routes! is deprecated. Please use inline_engine_routes! instead.")
      inline_engine_routes!
    end

    def inline_engine_routes!
      ::RailsSettingsUi::ApplicationController.helper ::RailsSettingsUi::RouteDelegator
    end

    def setup
      yield self
    end

    def settings_klass
      settings_class.constantize
    end

    def setting_config(name)
      defined_fields = RailsSettingsUi.settings_klass.public_send(:all).defined_fields
      defined_fields.find { |s| s[:key] == name }
    end

    def default_settings
      rsc_version = Gem.loaded_specs['rails-settings-cached'].version.to_s

      if rsc_version >= '2.7.0'
        defined_fields = RailsSettingsUi.settings_klass.public_send(:all).defined_fields
        settings = defined_fields.each_with_object({}) { |s, hsh| hsh[s[:key]] = s[:default] }.with_indifferent_access
        settings.reject { |name, _description| ignored_settings.include?(name.to_sym) }
      else
        settings = RailsSettings::Default.instance.with_indifferent_access
        settings.reject { |name, _description| ignored_settings.include?(name.to_sym) }
      end
    end
  end
end
