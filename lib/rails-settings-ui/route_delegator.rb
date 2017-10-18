module RailsSettingsUi::RouteDelegator
  # delegate url helpers to another engine
  def method_missing(method, *args, &block)
    if engine_route_method?(method)
      send(RailsSettingsUi.engine_name).send(method, *args)
    else
      super
    end
  end

  def respond_to?(method)
    super || engine_route_method?(method)
  end

  private
  def engine_route_method?(method)
    method.to_s =~ /_(?:path|url)$/ && send(RailsSettingsUi.engine_name).respond_to?(method)
  end
end
