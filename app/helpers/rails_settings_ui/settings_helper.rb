module RailsSettingsUi::SettingsHelper
  def setting_field(setting_name, setting_value, all_settings)
    if RailsSettingsUi.settings_displayed_as_select_tag.include?(setting_name.to_sym)
      select_tag_field(setting_name, setting_value)
    elsif setting_value.is_a?(Array)
      checkboxes_group_field(setting_name, all_settings)
    elsif [TrueClass, FalseClass].include?(setting_value.class)
      checkbox_field(setting_name, setting_value)
    else
      text_field(setting_name, setting_value)
    end
  end

  def select_tag_field(setting_name, setting_value)
    default_setting_values = I18n.t("settings.attributes.#{setting_name}.labels", default: {}).map do |label, value|
      [label, value]
    end
    select_tag("settings[#{setting_name.to_s}]", options_for_select(default_setting_values, setting_value))
  end

  def checkboxes_group_field(setting_name, all_settings)
    field = ""
    Settings.defaults[setting_name.to_sym].each do |value|
      field << check_box_tag("settings[#{setting_name.to_s}][#{value.to_s}]", nil, all_settings[setting_name.to_s].include?(value), style: "margin: 0 10px;")
      field << label_tag("settings[#{setting_name.to_s}][#{value.to_s}]", I18n.t("settings.attributes.#{setting_name}.labels.#{value}", default: value.to_s), style: "display: inline-block;")
    end
    field.html_safe
  end

  def checkbox_field(setting_name, setting_value)
    check_box_tag("settings[#{setting_name.to_s}]", nil, setting_value).html_safe
  end

  def text_field(setting_name, setting_value)
    field = if setting_value.to_s.size > 30
      text_area_tag("settings[#{setting_name}]", setting_value.to_s, rows: 10)
    else
      text_field_tag("settings[#{setting_name}]", setting_value.to_s)
    end

    help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
    field + (help_block_content.presence && content_tag(:span, help_block_content, class: 'help-block'))
  end
end
