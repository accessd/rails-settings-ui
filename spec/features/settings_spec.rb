require 'spec_helper'

describe "Settings interface", :type => :feature do
  after do
    RailsSettingsUi.settings_displayed_as_select_tag = []
    RailsSettingsUi.ignored_settings = []
  end

  describe "settings display correctly for" do
    it "string" do
      visit "/settings"
      expect(page).to have_selector('input#settings_project_name[type=text]')
    end

    it "long text" do
      visit "/settings"
      expect(page).to have_selector('textarea#settings_description')
    end

    it "boolean" do
      visit "/settings"
      expect(page).to have_selector('input#settings_check_something[type=checkbox]')
    end

    describe "array" do
      it "should display as checkboxes group by default" do
        visit "/settings"
        expect(page).to have_selector('input#settings_mode_manual[type=checkbox]')
        expect(page).to have_selector('input#settings_mode_auto[type=checkbox]')
      end

      it "should display as select if setting defined in RailsSettingsUi.settings_displayed_as_select_tag" do
        RailsSettingsUi.settings_displayed_as_select_tag = [:mode]
        visit "/settings"
        expect(page).to have_selector('select#settings_mode')
      end
    end    
  end

  describe "if setting defined in RailsSettingsUi.ignored_settings" do
    it "should not to be displayed" do
      RailsSettingsUi.ignored_settings = [:mode]
      visit "/settings"
      expect(page).not_to have_selector('select#settings_mode')
    end
  end

  describe "validations" do
    it "should validate numeric setting" do
      visit "/settings"
      fill_in("settings[limit]", with: "test")
      click_on I18n.t("settings.index.save_all")
      expect(page).to have_content("Invalid numeric")
    end

    it "should validate hash setting" do
      visit "/settings"
      fill_in("settings[style]", with: "test")
      click_on I18n.t("settings.index.save_all")
      expect(page).to have_content("Invalid hash")
    end
  end
end