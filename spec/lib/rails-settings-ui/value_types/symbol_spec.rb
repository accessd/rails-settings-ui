require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Symbol do
  describe "#cast" do
    it "should cast to symbol" do
      boolean_type = RailsSettingsUi::ValueTypes::Symbol.new("foo")
      expect(boolean_type.cast).to eq(:foo)
    end
  end
end