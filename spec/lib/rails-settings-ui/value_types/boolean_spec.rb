require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Boolean do
  describe "#cast" do
    it "should cast to true" do
      boolean_type = RailsSettingsUi::ValueTypes::Boolean.new("on")
      expect(boolean_type.cast).to eq(true)
    end
  end
end