require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class Array < RailsSettingsUi::ValueTypes::Base
      def cast
        # Array presented in checkboxes
        if ["Hash", "ActiveSupport::HashWithIndifferentAccess"].include?(value.class.name)
          value.keys.map!(&:to_sym)
        # or in select tag
        else
          value.to_sym
        end
      end
    end
  end
end