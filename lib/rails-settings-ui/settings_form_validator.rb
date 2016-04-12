require 'dry-validation'

module RailsSettingsUi
  class SettingsSchema < Dry::Validation::Schema::Form
  end

  class SettingsFormValidator
    VALIDATABLE_TYPES = {
      Fixnum => :int?,
      Float => :float?,
      ActiveSupport::Duration => :int?,
      ActiveSupport::HashWithIndifferentAccess => nil
    }.freeze

    def initialize(default_settings, settings)
      @default_settings = default_settings
      @settings = settings
      build_validation_schema
    end

    def validate
      errors = @schema.call(@settings).messages
      puts errors.inspect
    end

    def build_validation_schema
      v = Dry::Validation::Schema::Value.new

      validatable_settings.each do |name, value|
        m = VALIDATABLE_TYPES[value.class]
        v.key(name.to_sym).required(m) if m
      end

      SettingsSchema.configure do |config|
        config.rules = v.rules
      end

      @schema = SettingsSchema.new
    end

    def validatable_settings
      @default_settings.select { |_, value| value.class.in?(VALIDATABLE_TYPES.keys) }
    end

  end
end
