require 'i18n'
require 'dry-validation'

module RailsSettingsUi
  class SettingsSchema < Dry::Validation::Schema::Form
  end

  module CustomPredicates
    include Dry::Logic::Predicates

    predicate(:form_hash?) do |value|
      begin
        JSON.parse(value.gsub(/\=\>/, ':'))
      rescue JSON::ParserError => e
        false
      end
    end
  end

  class SettingsFormValidator
    VALIDATABLE_TYPES = {
      Fixnum => :int?,
      Float => :float?,
      ActiveSupport::Duration => :int?,
      ActiveSupport::HashWithIndifferentAccess => :form_hash?
    }.freeze

    def initialize(default_settings, settings)
      @default_settings = default_settings
      @settings = settings
      build_validation_schema
    end

    def errors
      @schema.call(@settings).messages
    end

    private

    def build_validation_schema
      v = Dry::Validation::Schema::Value.new

      validatable_settings.each do |name, value|
        predicate = VALIDATABLE_TYPES[value.class]
        v.key(name.to_sym).required(predicate) if predicate
      end

      SettingsSchema.configure do |config|
        config.rules = v.rules
        config.messages = :i18n
        config.predicates = CustomPredicates
      end

      @schema = SettingsSchema.new
    end

    def validatable_settings
      @default_settings.select { |_, value| value.class.in?(VALIDATABLE_TYPES.keys) }
    end

  end
end
