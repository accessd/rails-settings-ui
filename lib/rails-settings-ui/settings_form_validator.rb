require 'i18n'
require 'dry-validation'

module RailsSettingsUi
  module CustomPredicates
    include Dry::Logic::Predicates

    predicate(:form_hash?) do |value|
      begin
        JSON.parse(value.gsub(/\=\>/, ':'))
      rescue JSON::ParserError
        false
      end
    end
  end

  class SettingsSchema < Dry::Validation::Schema::Form
    predicates(CustomPredicates)
  end

  class SettingsFormValidator
    VALIDATABLE_TYPES = {
      (1.class == Integer ? Integer : Fixnum) => :int?,
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
      @schema.call(@settings.to_hash).messages
    end

    private

    def build_validation_schema
      registry = Dry::Validation::PredicateRegistry.new(CustomPredicates)
      v = Dry::Validation::Schema::Value.new(registry: registry)

      validatable_settings.each do |name, value|
        predicate = VALIDATABLE_TYPES[value.class]
        v.required(name.to_sym).filled(predicate) if predicate
      end

      SettingsSchema.configure do |config|
        config.rules = v.rules
        config.messages = :i18n
      end

      @schema = SettingsSchema.new
    end

    def validatable_settings
      @default_settings.select { |_, value| value.class.in?(VALIDATABLE_TYPES.keys) }
    end

  end
end
