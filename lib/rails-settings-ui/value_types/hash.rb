require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class Hash < RailsSettingsUi::ValueTypes::Base
      def cast
        value
      end

      def validate
        begin
          self.value = JSON.parse(value.gsub(/\=\>/, ':'))
        rescue JSON::ParserError => e
          self.errors << I18n.t("settings.errors.invalid_hash", default: 'Invalid')
        end
      end
    end
  end
end