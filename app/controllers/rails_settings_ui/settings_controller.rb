class RailsSettingsUi::SettingsController < RailsSettingsUi::ApplicationController
  include RailsSettingsUi::SettingsHelper
  before_action :collection
  before_action :validate_settings, only: :update_all

  def index
  end

  def update_all
    if @errors.any?
      render :index
    else
      coerced_values.each { |name, value| RailsSettingsUi.settings_klass[name] = value }
      flash[:success] = t('settings.index.settings_saved')
      redirect_to [:settings]
    end
  end

  private

  def collection
    all_settings_without_ignored = all_settings.reject{ |name, _description| RailsSettingsUi.ignored_settings.include?(name.to_sym) }
    @settings = Hash[all_settings_without_ignored]
    @errors = {}
  end

  def validate_settings
    # validation schema accepts hash (http://dry-rb.org/gems/dry-validation/forms/) so we're converting
    # ActionController::Parameters => ActiveSupport::HashWithIndifferentAccess
    @errors = RailsSettingsUi::SettingsFormValidator.new(default_settings, settings_from_params).errors
    @errors.merge(RailsSettingsUi.custom_schema.call(settings_from_params).messages)
  end

  def coerced_values
    RailsSettingsUi::SettingsFormCoercible.new(default_settings, settings_from_params).coerce!
  end

  def settings_from_params
    settings_params = params['settings'].deep_dup
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
