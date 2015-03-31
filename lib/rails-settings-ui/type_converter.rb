require_relative "value_types/string"
require_relative "value_types/symbol"
require_relative "value_types/fixnum"
require_relative "value_types/hash"
require_relative "value_types/duration"
require_relative "value_types/float"
require_relative "value_types/array"
require_relative "value_types/boolean"

module RailsSettingsUi
  class UnknownDefaultValueType < StandardError;end

  class TypeConverter
    VALUE_TYPES_MAP = {
      String => RailsSettingsUi::ValueTypes::String,
      Symbol => RailsSettingsUi::ValueTypes::Symbol,
      Fixnum => RailsSettingsUi::ValueTypes::Fixnum,
      ActiveSupport::HashWithIndifferentAccess => RailsSettingsUi::ValueTypes::Hash,
      ActiveSupport::Duration => RailsSettingsUi::ValueTypes::Float,
      Float => RailsSettingsUi::ValueTypes::Float,
      Array => RailsSettingsUi::ValueTypes::Array,
      FalseClass => RailsSettingsUi::ValueTypes::Boolean,
      TrueClass => RailsSettingsUi::ValueTypes::Boolean
    }

    def self.cast(settings)
      errors = {}
      settings.each do |name, value|
        type = setting_value_type(name, value)
        settings[name] = type.cast
        if type.errors.any?
          errors[name.to_sym] = type.errors.join(', ')
        end
      end
      settings = set_non_presented_boolean_settings_to_false(settings)

      settings[:errors] = errors
      settings
    end

    def self.setting_value_type(name, value)
      default_setting_value_type = RailsSettingsUi.settings_klass.defaults[name.to_sym].class
      unless VALUE_TYPES_MAP.keys.include?(default_setting_value_type)
        raise RailsSettingsUi::UnknownDefaultValueType, "Unknown default value type #{default_setting_value_type}"
      end

      setting_value_type_class = VALUE_TYPES_MAP[default_setting_value_type]
      setting_value_type_class.new(value)
    end

    def self.set_non_presented_boolean_settings_to_false(settings)
      RailsSettingsUi.settings_klass.defaults.each do |name, value|
        if !settings[name.to_sym].present? && [TrueClass, FalseClass].include?(value.class)
          settings[name.to_sym] = false
        end
      end
      settings
    end
  end
end
