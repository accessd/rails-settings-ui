require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Fixnum do
  describe "#cast" do
    it "should cast to integer" do
      fixnum_type = RailsSettingsUi::ValueTypes::Fixnum.new("29")
      expect(fixnum_type.cast).to eq(29)
    end
  end

  describe "if value not numeric" do
    it "should be not valid" do
      fixnum_type = RailsSettingsUi::ValueTypes::Fixnum.new("qwerty")
      expect(fixnum_type.valid?).to be_falsey
    end
  end
end