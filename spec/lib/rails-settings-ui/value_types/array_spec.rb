require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Array do
  describe "#cast" do
    it "should cast hash as array of keys as symbols" do
      array_type = RailsSettingsUi::ValueTypes::Array.new({auto: "on", manual: "on"})
      expect(array_type.cast).to eq([:auto, :manual])
    end

    it "if setting presented as select should cast select value as symbol" do
      array_type = RailsSettingsUi::ValueTypes::Array.new("auto")
      expect(array_type.cast).to eq(:auto)
    end
  end
end