require 'spec_helper'

describe RailsSettingsUi::TypeConverter do
  describe "default setting value type unknown" do
    it "should raise exception" do
      defined_fields = RailsSettingsUi.settings_klass.public_send(:all).defined_fields
      RailsSettingsUi.settings_klass.instance_variable_set(:@defined_fields, [])
      Settings.class_eval do
        field :project_name, type: :string, default: nil
      end

      expect do
        RailsSettingsUi::TypeConverter.cast({project_name: :test})
      end.to raise_error(RailsSettingsUi::UnknownDefaultValueType)

      RailsSettingsUi.settings_klass.instance_variable_set(:@defined_fields, defined_fields)
    end
  end

  describe "if setting not passed" do
    describe "and default value type is boolean" do
      it "should to set false" do
        Settings.class_eval do
          field :check_something, type: :boolean, default: true
        end
        settings = RailsSettingsUi::TypeConverter.cast({})
        expect(settings[:check_something]).to be_falsey
      end
    end
  end

  describe ".cast" do
    it "should cast settings value by default setting type" do
      Settings.class_eval do
        field :symbol, default: :foo
      end

      settings = RailsSettingsUi::TypeConverter.cast({symbol: "bar", limit: "100"})
      expect(settings[:symbol]).to equal(:bar)
      expect(settings[:limit]).to equal(100)
    end
  end
end
