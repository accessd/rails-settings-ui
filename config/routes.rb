RailsSettingsUi::Engine.routes.draw do
  get '/' => 'settings#index', as: :settings
  put '/update_all' => 'settings#update_all'
end
