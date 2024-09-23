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
      # ActiveSupport::HashWithIndifferentAccess => RailsSettingsUi::ValueTypes::Hash,
      ActiveSupport::Duration => RailsSettingsUi::ValueTypes::Float,
      Float => RailsSettingsUi::ValueTypes::Float,
      Array => RailsSettingsUi::ValueTypes::Array,
      FalseClass => RailsSettingsUi::ValueTypes::Boolean,
      TrueClass => RailsSettingsUi::ValueTypes::Boolean,
      boolean: RailsSettingsUi::ValueTypes::Boolean,
      string: RailsSettingsUi::ValueTypes::String,
      integer: RailsSettingsUi::ValueTypes::Fixnum,
      float: RailsSettingsUi::ValueTypes::Float,
      array: RailsSettingsUi::ValueTypes::Array,
      hash: RailsSettingsUi::ValueTypes::Hash
    }

    def self.cast(settings)
      errors = {}
      settings.each do |name, value|
        sc = RailsSettingsUi.setting_config(name.to_s)
        type = setting_value_type(name, value, sc)
        settings[name] = type.cast
        if type.errors.any?
          errors[name.to_sym] = type.errors
        end
      end
      settings = set_non_presented_settings(settings)

      settings[:errors] = errors
      settings
    end

    def self.setting_value_type(name, value, setting_config)
      default_setting_value_type = if setting_config[:type].nil? || setting_config[:type] == :string
                                     setting_config[:default].class
                                   else
                                     setting_config[:type]
                                   end

      unless VALUE_TYPES_MAP.keys.include?(default_setting_value_type)
        raise RailsSettingsUi::UnknownDefaultValueType,
          "Unknown default value type #{default_setting_value_type} for #{name}"
      end

      # puts "--- #{name}: #{default_setting_value_type} ---"
      setting_value_type_class = VALUE_TYPES_MAP[default_setting_value_type]
      setting_value_type_class.new(value)
    end

    def self.set_non_presented_settings(settings)
      RailsSettingsUi.default_settings.each do |name, value|
        if !settings[name.to_sym].present?
          if [TrueClass, FalseClass].include?(value.class)
            settings[name.to_sym] = false
          elsif [Array].include?(value.class)
            settings[name.to_sym] = []
          end
        end
      end
      settings
    end
  end
end
