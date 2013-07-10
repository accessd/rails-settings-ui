module RailsSettingsUi::SettingsHelper
  def setting_field(setting_name, setting_value)
    if setting_value.is_a?(Array)
      field = ""
      Settings.defaults[setting_name.to_sym].each do |value|
        field << check_box_tag("settings[#{setting_name.to_s}][#{value.to_s}]", nil, Settings.defaults.merge(Settings.all)[setting_name.to_s].include?(value), style: "margin: 0 10px;")
        field << label_tag("settings[#{setting_name.to_s}][#{value.to_s}]", I18n.t("admin.settings.checkboxes.#{value}", default: value.to_s), style: "display: inline-block;")
      end
      return field.html_safe
    elsif [TrueClass, FalseClass].include?(setting_value.class)
      return check_box_tag("settings[#{setting_name.to_s}]", nil, setting_value).html_safe
    else
      text_field = if setting_value.to_s.size > 30
        text_area_tag("settings[#{setting_name}]", setting_value.to_s, rows: 10)
      else
        text_field_tag("settings[#{setting_name}]", setting_value.to_s)
      end

      help_block_content = I18n.t("admin.settings.help_blocks.#{setting_name}", default: "")
      text_field + (help_block_content.presence && content_tag(:span, help_block_content, class: 'help-block'))
    end
  end

  def self.is_numeric?(value)
    !value.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
  end
end
