require 'spec_helper'

describe "Settings interface" do
  describe "list of settings" do
    it "display correctly" do
      visit "/settings"
      page.should have_text('Settings')
    end
  end
end