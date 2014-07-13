require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Base do
  describe "if value have any errors" do
    it "should not be valid" do
      base_type = RailsSettingsUi::ValueTypes::Base.new("test")
      base_type.errors << "Invalid"
      expect(base_type.valid?).to be_falsey
    end
  end

  describe "#value_numeric?" do
    it "if value is numeric should return true" do
      base_type = RailsSettingsUi::ValueTypes::Base.new(349)
      expect(base_type.value_numeric?).to be_truthy
    end

    it "if value is not numeric should return false" do
      base_type = RailsSettingsUi::ValueTypes::Base.new("str")
      expect(base_type.value_numeric?).to be_falsey
    end
  end
end