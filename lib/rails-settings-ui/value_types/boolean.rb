require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class Boolean < RailsSettingsUi::ValueTypes::Base
      def cast
        case value
        when 'off'
          self.value = false
        else
          self.value = true
        end
      end
    end
  end
end