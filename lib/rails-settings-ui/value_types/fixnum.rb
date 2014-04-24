require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class Fixnum < RailsSettingsUi::ValueTypes::Base
      def cast
        value.to_i
      end
    
      def validate
        unless value_numeric?
          self.errors << I18n.t("settings.errors.invalid_numeric", default: 'Invalid')
        end
      end
    end
  end
end