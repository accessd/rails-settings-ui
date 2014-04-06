require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class Symbol < RailsSettingsUi::ValueTypes::Base
      def cast
        value.to_sym
      end
    end
  end
end