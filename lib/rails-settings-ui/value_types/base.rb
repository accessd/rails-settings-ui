module RailsSettingsUi
  module ValueTypes
    class Base
      attr_accessor :value, :errors
    
      def initialize(value)
        self.value = value
        self.errors = []
        validate
      end
    
      def cast
        raise NotImplementedError
      end
    
      def valid?
        !errors.any?
      end

      def value_numeric?
        !value.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
      end
    
      protected
    
      def validate
      end
    end
  end
end