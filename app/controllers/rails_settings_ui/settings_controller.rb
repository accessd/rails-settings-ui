class RailsSettingsUi::SettingsController < RailsSettingsUi::ApplicationController
  include RailsSettingsUi::SettingsHelper
  before_filter :collection
  before_filter :cast_settings_params, only: :update_all

  def index
  end

  def update_all
    if @casted_settings[:errors].any?
      render :index
    else
      @casted_settings.map { |setting| RailsSettingsUi.settings_klass[setting[0]] = setting[1] if setting[0] != "errors" }
      redirect_to [:settings]
    end
  end

  private

  def collection
    all_settings = RailsSettingsUi.settings_klass.defaults.merge(RailsSettingsUi.settings_klass.public_send(get_collection_method))
    all_settings_without_ignored = all_settings.reject{ |name, description| RailsSettingsUi.ignored_settings.include?(name.to_sym) }
    @settings = Hash[all_settings_without_ignored]
  end

  def cast_settings_params
    @casted_settings = RailsSettingsUi::TypeConverter.cast(params["settings"])
  end
end
