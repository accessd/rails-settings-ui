module RailsSettingsUi::SettingsHelper
  def self.cast(requires_cast)
    requires_cast[:errors] = {}
    requires_cast.each do |var_name, value|
      case Settings.defaults[var_name.to_sym]
        when Fixnum
          if is_numeric?(value)
            requires_cast[var_name] = value.to_i
          else
            requires_cast[:errors][var_name.to_sym] = I18n.t("settings.errors.invalid_numeric", default: 'Invalid')
          end
        when ActiveSupport::HashWithIndifferentAccess
          begin
            requires_cast[var_name] = JSON.parse(value.gsub(/\=\>/, ':'))
          rescue JSON::ParserError => e
            requires_cast[:errors][var_name.to_sym] = I18n.t("settings.errors.invalid_hash", default: 'Invalid')
          end
        when Float
          if is_numeric?(value)
            requires_cast[var_name] = value.to_f
          else
            requires_cast[:errors][var_name.to_sym] = I18n.t("settings.errors.invalid_numeric", default: 'Invalid')
          end
        when Array
          requires_cast[var_name] = value.keys.map!(&:to_sym)
        when FalseClass, TrueClass
          requires_cast[var_name] = true
      end
    end
    Settings.defaults.each do |name, value|
      if !requires_cast[name.to_sym].present? && [TrueClass, FalseClass].include?(value.class)
        requires_cast[name.to_sym] = false
      end
    end

    requires_cast
  end

  def setting_field(setting_name, setting_value)
    if setting_value.is_a?(Array)
      field = ""
      Settings.defaults[setting_name.to_sym].each do |value|
        field << check_box_tag("settings[#{setting_name.to_s}][#{value.to_s}]", nil, Settings.defaults.merge(Settings.all)[setting_name.to_s].include?(value), style: "margin: 0 10px;")
        field << label_tag("settings[#{setting_name.to_s}][#{value.to_s}]", I18n.t("settings.attributes.#{setting_name}.checkbox_labels.#{value}", default: value.to_s), style: "display: inline-block;")
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

      help_block_content = I18n.t("settings.attributes.#{setting_name}.help_block", default: '')
      text_field + (help_block_content.presence && content_tag(:span, help_block_content, class: 'help-block'))
    end
  end

  def self.is_numeric?(value)
    !value.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
  end
end
