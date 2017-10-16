module RailsSettingsUi::MainAppRouteDelegator
  # delegate url helpers to main_app
  def method_missing(method, *args, &block)
    if main_app_route_method?(method)
      send(RailsSettingsUi.name_engine).send(method, *args)
    else
      super
    end
  end

  def respond_to?(method)
    super || main_app_route_method?(method)
  end

  private
  def main_app_route_method?(method)
    method.to_s =~ /_(?:path|url)$/ && send(RailsSettingsUi.name_engine).respond_to?(method)
  end
end
