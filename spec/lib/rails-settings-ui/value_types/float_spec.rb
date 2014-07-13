require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Float do
  describe "#cast" do
    it "should cast to float" do
      fixnum_type = RailsSettingsUi::ValueTypes::Float.new("99.21")
      expect(fixnum_type.cast).to eq(99.21)
    end
  end

  describe "if value not numeric" do
    it "should be not valid" do
      fixnum_type = RailsSettingsUi::ValueTypes::Float.new("qwerty")
      expect(fixnum_type.valid?).to be_falsey
    end
  end
end