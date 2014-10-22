module RailsSettingsUi
  class Setting
    attr_accessor :name, :value, :errors

    def initialize(name, value)
      self.name = name
      self.value = value
    end

    def valid?
      errors.any?
    end

    def error_message
      errors.join(', ')
    end
  end
end
