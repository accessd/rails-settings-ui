require 'spec_helper'

describe RailsSettingsUi::ValueTypes::Duration do
  describe "#cast" do
    it "should cast string to duration" do
      param = "#{5.hours}"
      fixnum_type = RailsSettingsUi::ValueTypes::Duration.new(param)
      expect(fixnum_type.cast).to eq(5.hours)
      expect(fixnum_type.cast).to be_instance_of(ActiveSupport::Duration)
    end
  end

  describe "if value not valid duration" do
    it "should be not valid" do
      fixnum_type = RailsSettingsUi::ValueTypes::Duration.new("one hour")
      expect(fixnum_type.valid?).to be_falsey
    end
  end
end