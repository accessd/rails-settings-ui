require_relative "base"

module RailsSettingsUi
  module ValueTypes
    class Symbol < RailsSettingsUi::ValueTypes::Base
      def self.[](value)
        value.to_sym
      end
    end
  end
end
