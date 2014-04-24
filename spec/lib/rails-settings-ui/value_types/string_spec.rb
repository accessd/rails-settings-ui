require 'spec_helper'

describe RailsSettingsUi::ValueTypes::String do
  describe "#cast" do
    it "should cast to string" do
      boolean_type = RailsSettingsUi::ValueTypes::String.new("foo")
      expect(boolean_type.cast).to eq("foo")
    end
  end
end