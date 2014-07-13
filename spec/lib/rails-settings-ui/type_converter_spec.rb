require 'spec_helper'

describe RailsSettingsUi::TypeConverter do
  describe "default setting value type unknown" do
    it "should raise exception" do
      Settings.defaults[:project_name] = nil
      expect do
        RailsSettingsUi::TypeConverter.cast({project_name: :test})
      end.to raise_error(RailsSettingsUi::UnknownDefaultValueType)
      Settings.defaults[:project_name] = "Dummy"
    end
  end

  describe "if setting not passed" do
    describe "and default value type is boolean" do
      it "should to set false" do
        Settings.defaults[:check_something] = true
        settings = RailsSettingsUi::TypeConverter.cast({})
        expect(settings[:check_something]).to be_falsey
      end
    end
  end

  describe ".cast" do
    it "should cast settings value by default setting type" do
      Settings.defaults[:project_name] = :foo
      settings = RailsSettingsUi::TypeConverter.cast({project_name: "bar", limit: "100"})
      expect(settings[:project_name]).to equal(:bar)
      expect(settings[:limit]).to equal(100)
      Settings.defaults[:project_name] = "Dummy"
    end
  end
end