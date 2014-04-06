require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class String < RailsSettingsUi::ValueTypes::Base
      def cast
        value.to_s
      end
    end
  end
end