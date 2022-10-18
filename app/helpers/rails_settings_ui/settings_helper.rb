module RailsSettingsUi::SettingsHelper
  def setting_field(setting_name, setting_value)
    if !RailsSettingsUi.default_settings.has_key?(setting_name.to_sym)
      message_for_default_value_missing
    elsif RailsSettingsUi.settings_displayed_as_select_tag.include?(setting_name.to_sym)
      select_tag_field(setting_name, setting_value)
    elsif setting_value.is_a?(Array)
      checkboxes_group_field(setting_name)
    elsif [TrueClass, FalseClass].include?(setting_value.class)
      checkbox_field(setting_name, setting_value)
    else
      text_field(setting_name, setting_value, class: 'form-control')
    end
  end

  def select_tag_field(setting_name, setting_value)
    default_options_from_locale = I18n.t("settings.attributes.#{setting_name}.labels", default: {}).map do |value, label|
      [label, value]
    end
    selected_value = if setting_value.is_a?(Array)
      default_value_for_setting(setting_name)
    else
      setting_value
    end
    default_options = if default_options_from_locale.empty?
      all_settings[setting_name.to_s].map {|v| [v, v]}
    else
      default_options_from_locale
    end
    field = select_tag("settings[#{setting_name}]", options_for_select(default_options, selected_value), class: 'form-control')
    help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
    field << content_tag(:span, help_block_content, class: 'help-block') if help_block_content.presence
    field.html_safe
  end

  def checkboxes_group_field(setting_name)
    field = ""
    all_setting_values = all_settings[setting_name.to_s].map(&:to_s)
    RailsSettingsUi.default_settings[setting_name.to_sym].each do |value|
      checked = all_setting_values.include?(value.to_s)
      field << check_box_tag("settings[#{setting_name}][#{value}]", nil, checked, style: "margin: 0 10px;")
      field << label_tag("settings[#{setting_name}][#{value}]", I18n.t("settings.attributes.#{setting_name}.labels.#{value}", default: value.to_s), style: "display: inline-block;")
    end
    help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
    field << content_tag(:span, help_block_content, class: 'help-block') if help_block_content.presence
    field.html_safe
  end

  def checkbox_field(setting_name, setting_value)
    help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
    fields = ""
    fields << hidden_field_tag("settings[#{setting_name}]", 'off').html_safe
    fields << check_box_tag("settings[#{setting_name}]", nil, setting_value).html_safe
    fields << content_tag(:span, help_block_content, class: 'help-block') if help_block_content.presence
    fields.html_safe
  end

  def text_field(setting_name, setting_value, options = {})
    field = if setting_value.to_s.size > 30
              text_area_tag("settings[#{setting_name}]", setting_value.to_s, options.merge(rows: 10))
            else
              text_field_tag("settings[#{setting_name}]", setting_value.to_s, options)
            end

    help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
    field + (help_block_content.presence && content_tag(:span, help_block_content, class: 'help-block'))
  end

  def message_for_default_value_missing
    content_tag(:span, I18n.t("settings.errors.default_missing"), class: "label label-warning")
  end

  def default_value_for_setting(setting_name)
    RailsSettingsUi.defaults_for_settings.with_indifferent_access[setting_name.to_sym]
  end

  def all_settings
    stored_settings = RailsSettingsUi.settings_klass.public_send(:all).each_with_object({}) do |s, hsh|
      hsh[s.var] = s.value
    end.with_indifferent_access

    stored_settings.merge(RailsSettingsUi.default_settings.merge(stored_settings))
  end
end
