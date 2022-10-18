class RailsSettingsUi::SettingsController < RailsSettingsUi::ApplicationController
  include RailsSettingsUi::SettingsHelper
  before_action :collection
  before_action :cast_settings_params, only: :update_all

  def index
  end

  def update_all
    if @casted_settings[:errors].any?
      @errors = @casted_settings[:errors]
      render :index
    else
      @casted_settings.map do |name, value|
        next if name == 'errors'

        sc = RailsSettingsUi.setting_config(name)
        next if sc[:readonly] == true

        RailsSettingsUi.settings_klass.public_send("#{name}=", value)
      end
      flash[:success] = t('settings.index.settings_saved')
      redirect_to [:settings]
    end
  end

  private

  def collection
    all_settings_without_ignored = all_settings.reject do |name, _description|
      RailsSettingsUi.ignored_settings.include?(name.to_sym)
    end
    @settings = Hash[all_settings_without_ignored]
    @errors = {}
  end

  def cast_settings_params
    @casted_settings = RailsSettingsUi::TypeConverter.cast(settings_from_params)
  end

  def settings_from_params
    settings_params = params['settings'].deep_dup || {}
    if settings_params.respond_to?(:to_unsafe_h)
      settings_params.to_unsafe_h
    else
      settings_params
    end
  end

  def default_settings
    RailsSettingsUi.default_settings
  end
end
