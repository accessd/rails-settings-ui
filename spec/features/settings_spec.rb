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
      save_and_open_page
      expect(page).to have_selector('input#settings_check_something[type=hidden]')
      expect(page).to have_selector('input#settings_check_something[type=checkbox]')
      expect(page).to have_selector('span.help-block', text: I18n.t("settings.attributes.check_something.help_block"))
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

  describe "settings missing in defaults, but present in db" do
    it "should show info message" do
      create_settings_in_db_which_missing_in_defaults
      visit "/settings"
      expect_setting_row_to_have_default_missing_message("company")
    end
  end

  def create_settings_in_db_which_missing_in_defaults
    Settings.create!(var: "company", value: "apple")
  end

  def setting_tr_element_for_name(setting_name)
    find("tr[data-name='#{setting_name}']")
  end

  def expect_setting_row_to_have_default_missing_message(setting_name)
    within tr = setting_tr_element_for_name(setting_name) do
      expect(tr.find(".setting-value")).to have_content(I18n.t("settings.errors.default_missing"))
    end
  end
end
