require_relative "value_types/string"
require_relative "value_types/symbol"
require_relative "value_types/fixnum"
require_relative "value_types/hash"
require_relative "value_types/duration"
require_relative "value_types/float"
require_relative "value_types/array"
require_relative "value_types/boolean"
require 'dry-types'

module RailsSettingsUi
  module Types
    include Dry::Types.module
  end

  class UnknownDefaultValueType < StandardError;end

  class TypeConverter
    VALUE_TYPES_MAP = {
      String => RailsSettingsUi::Types::Coercible::String,
      Symbol => RailsSettingsUi::ValueTypes::Symbol,
      Fixnum => RailsSettingsUi::Types::Form::Int,
      ActiveSupport::HashWithIndifferentAccess => RailsSettingsUi::ValueTypes::Hash,
      ActiveSupport::Duration => RailsSettingsUi::Types::Form::Float,
      Float => RailsSettingsUi::Types::Form::Float,
      Array => RailsSettingsUi::ValueTypes::Array,
      FalseClass => RailsSettingsUi::Types::Form::Bool,
      TrueClass => RailsSettingsUi::Types::Form::Bool
    }.freeze

    def self.schema
      Dry::Validation.Form do
        key(:limit) { int? }
      end
    end

    def self.cast(settings)
      errors = {}
      errors = schema.call(limit: settings[:limit]).messages
      binding.pry
      settings.each do |name, value|
        settings[name] = setting_value_type(name, value)
        # if type.errors.any?
        #   errors[name.to_sym] = type.errors.join(', ')
        # end
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

      VALUE_TYPES_MAP[default_setting_value_type][value]
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
