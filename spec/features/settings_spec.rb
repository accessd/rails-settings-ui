require 'spec_helper'

describe "Settings interface", type: :feature do
  before do
    visit_settings_page
  end

  after do
    RailsSettingsUi.settings_displayed_as_select_tag = []
    RailsSettingsUi.ignored_settings = []
    RailsSettingsUi.defaults_for_settings = {}
  end

  describe "display settings correctly for" do
    it "string" do
      expect(page).to have_selector('input#settings_project_name[type=text]')
    end

    it "long text" do
      expect(page).to have_selector('textarea#settings_description')
    end

    it "boolean" do
      expect(page).to have_selector('input#settings_check_something[type=checkbox]')
      expect(page).to have_selector('span.help-block', text: I18n.t("settings.attributes.check_something.help_block"))
    end

    describe "array" do
      it "should display as checkboxes group by default" do
        expect(page).to have_selector('input#settings_mode_manual[type=checkbox]')
        expect(page).to have_selector('input#settings_mode_auto[type=checkbox]')
      end

      it "should display as select if setting defined in RailsSettingsUi.settings_displayed_as_select_tag" do
        RailsSettingsUi.settings_displayed_as_select_tag = [:mode]
        visit_settings_page
        expect(page).to have_selector('select#settings_mode')
        expect(page).to have_selector('span.help-block', text: I18n.t("settings.attributes.mode.help_block"))
      end
    end
  end

  describe "if setting defined in RailsSettingsUi.ignored_settings" do
    it "should not to be displayed" do
      RailsSettingsUi.ignored_settings = [:mode]
      visit_settings_page
      expect(page).not_to have_selector('select#settings_mode')
    end
  end

  describe "select tags" do
    it "default selected value" do
      RailsSettingsUi.settings_displayed_as_select_tag = [:mode]
      RailsSettingsUi.defaults_for_settings = {mode: :manual}
      visit_settings_page
      expect(find('select#settings_mode').value).to eq('manual')
    end

    it "default labels for options" do
      RailsSettingsUi.settings_displayed_as_select_tag = [:locale]
      visit_settings_page
      expect(find('select#settings_locale').find(:option, 'en').value).to eq('en')
    end
  end

  describe "validations" do
    it "should validate numeric setting" do
      fill_in("settings[limit]", with: "test")
      click_on_save
      expect(page).to have_content("Invalid numeric")
    end

    it "should validate hash setting" do
      fill_in("settings[style]", with: "test")
      click_on_save
      expect(page).to have_content("Invalid hash")
    end
  end

  describe "settings missing in defaults, but present in db" do
    it "should show info message" do
      create_settings_in_db_which_missing_in_defaults
      visit_settings_page
      expect_setting_row_to_have_default_missing_message("company")
    end
  end

  describe 'update settings' do
    it 'numeric' do
      expect_update_setting(:limit, '552', 552)
    end

    it 'symbol' do
      expect_update_setting(:project_status, 'new', :new)
    end

    it 'float' do
      expect_update_setting(:angle, '55.4', 55.4)
    end

    it 'hash' do
      h = {
        "border_color" => "e0e0e0",
        "block_color" => "000000"
      }

      form_value = JSON.generate(h)
      fill_in("settings[style]", with: form_value)
      click_on_save
      expect(find("#settings_style").value).to eq("{\"border_color\"=>\"e0e0e0\", \"block_color\"=>\"000000\"}")
      expect(Settings[:style]).to eq(h)
    end

    describe 'array' do
      it 'as checkboxes group' do
        check 'settings_mode_manual'
        uncheck 'settings_mode_auto'
        click_on_save
        expect(find('#settings_mode_auto')).not_to be_checked
        expect(find('#settings_mode_manual')).to be_checked
        expect(Settings[:mode]).to eq([:manual])

        uncheck 'settings_mode_manual'
        click_on_save
        expect(find('#settings_mode_auto')).not_to be_checked
        expect(find('#settings_mode_manual')).not_to be_checked
        expect(Settings[:mode]).to eq([])

        check 'settings_mode_manual'
        check 'settings_mode_auto'
        click_on_save
        expect(find('#settings_mode_auto')).to be_checked
        expect(find('#settings_mode_manual')).to be_checked
        expect(Settings[:mode]).to eq([:auto, :manual])
      end

      it 'as select' do
        RailsSettingsUi.settings_displayed_as_select_tag = [:mode]
        visit_settings_page
        select 'Auto', from: 'settings_mode'
        click_on_save
        expect(find('select#settings_mode').value).to eq('auto')
        expect(Settings[:mode]).to eq(:auto)

        select 'Manual', from: 'settings_mode'
        click_on_save
        expect(find('select#settings_mode').value).to eq('manual')
        expect(Settings[:mode]).to eq(:manual)
      end
    end

    it 'shows settings saved message' do
      click_on_save
      expect_there_is_success_flash_message(I18n.t('settings.index.settings_saved'))
    end
  end

  begin 'Helper methods'

    def expect_update_setting(name, form_value, db_value)
      fill_in("settings[#{name}]", with: form_value)
      click_on_save
      expect(find("#settings_#{name}").value).to eq(form_value)
      expect(Settings[name]).to eq(db_value)
    end

    def visit_settings_page
      visit '/settings'
    end

    def click_on_save
      click_on I18n.t("settings.index.save_all")
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

    def expect_there_is_success_flash_message(msg)
      expect(find('.alert-success')).to have_content(msg)
    end
  end
end
