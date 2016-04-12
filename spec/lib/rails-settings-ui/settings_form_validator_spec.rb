require 'spec_helper'

describe RailsSettingsUi::SettingsFormValidator do

  describe "#validate" do
    it do
      validator = described_class.new(Settings.defaults, {'limit' => 'as'})
      validator.validate
    end
  end

end
