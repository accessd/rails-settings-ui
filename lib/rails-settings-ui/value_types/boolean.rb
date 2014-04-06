require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class Boolean < RailsSettingsUi::ValueTypes::Base
      def cast
        self.value = true
      end
    end
  end
end