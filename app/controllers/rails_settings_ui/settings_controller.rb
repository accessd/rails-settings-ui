class RailsSettingsUi::SettingsController < RailsSettingsUi::ApplicationController
  before_filter :collection
  before_filter :cast_settings_params, only: :update_all

  def index
  end

  def update_all
    if @casted_settings[:errors].any?
      render :index
    else
      @casted_settings.map { |setting| Settings[setting[0]] = setting[1] if setting[0] != "errors" }
      redirect_to [:settings]
    end
  end

  private

  def collection
    @settings = Hash[Settings.defaults.merge(Settings.all)]
  end

  def cast_settings_params
    @casted_settings = RailsSettingsUi::SettingsHelper.cast(params["settings"])
  end
end