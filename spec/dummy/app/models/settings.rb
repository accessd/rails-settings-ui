class Settings < RailsSettings::CachedSettings
  defaults[:project_name] = "Dummy"
  defaults[:project_domain] = "dummy.com"
  defaults[:company_name] = "Dummy Limited"
end
