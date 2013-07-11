require 'rails-settings-ui'
require 'settings'

#= Application-specific
#
# # You can specify a controller for RailsSettingsUi::ApplicationController to inherit from:
# RailsSettingsUi.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
#
# # Render RailsSettingsUi inside a custom layout (set to 'application' to use app layout, default is RailsSettingsUi's own layout)
# RailsSettingsUi::ApplicationController.layout 'admin'

Rails.application.config.to_prepare do
  # If you use a *custom layout*, make route helpers available to RailsSettingsUi:
  # RailsSettingsUi.inline_main_app_routes!
end

Settings.module_eval do
  def self.cast(requires_cast)
    requires_cast[:errors] = {}
    requires_cast.each do |var_name, value|
      case defaults[var_name.to_sym]
        when Fixnum
          if RailsSettingsUi::SettingsHelper.is_numeric?(value)
            requires_cast[var_name] = value.to_i
          else
            requires_cast[:errors][var_name.to_sym] = I18n.t("admin.settings.errors.invalid_numeric", default: 'Invalid')
          end
        when ActiveSupport::HashWithIndifferentAccess
          begin
            requires_cast[var_name] = JSON.parse(value.gsub(/\=\>/, ':'))
          rescue JSON::ParserError => e
            requires_cast[:errors][var_name.to_sym] = I18n.t("admin.settings.errors.invalid_hash", default: 'Invalid')
          end
        when Float
          if RailsSettingsUi::SettingsHelper.is_numeric?(value)
            requires_cast[var_name] = value.to_f
          else
            requires_cast[:errors][var_name.to_sym] = I18n.t("admin.settings.errors.invalid_numeric", default: 'Invalid')
          end
        when Array
          requires_cast[var_name] = value.keys.map!(&:to_sym)
        when FalseClass, TrueClass
          requires_cast[var_name] = true
      end
    end
    defaults.each do |name, value|
      if !requires_cast[name.to_sym].present? && [TrueClass, FalseClass].include?(value.class)
        requires_cast[name.to_sym] = false
      end
    end

    requires_cast
  end	
end
