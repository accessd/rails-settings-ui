Rails settings UI
================================

A Rails Engine to manage your application settings. Includes validation. Compatible with Rails 3.
It compatible with [rails-settings-cached gem](https://github.com/huacnlee/rails-settings-cached).

How to
-----

Add to Gemfile

    gem 'rails-settings-ui'


    # adds initializer and route:
    rails g rails_settings_ui:install

Routing
-------

    # engine root:
    rails_settings_ui_path

I18n
-------------

You can localize:

*  Settings names, eg:

```yaml
  settings:
    attributes:
      launch_mode: # setting name
        name: 'Launch mode'
```

*  Checkbox labels for array options, eg:

```yaml
  settings:
    attributes:
      launch_mode:
        checkboxes:
          auto: 'Auto mode'
          manual: 'Manual mode'
```

*  Help blocks for settings, eg:

```yaml
  settings:
    attributes:
      launch_mode: <- setting name
        help_block: 'Rocket launch mode'
```

Views
-------------

    # Use admin layout:
    RailsSettingsUi::ApplicationController.layout 'admin'
    # If you are using a custom layout, you will want to make app routes available to rails-setting-ui:
    Rails.application.config.to_prepare { RailsSettingsUi.inline_main_app_routes! }


Authentication & authorization
------------------------------

You can specify the parent controller for settings controller, and it will inherit all before filters.
Note that this must be placed before any other references to rails-setting-ui application controller in the initializer:

    RailsSettingsUi.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'

Alternatively, to have custom rules just for rails-setting-ui you can:

    Rails.application.config.to_prepare do
      RailsEmailPreview::ApplicationController.module_eval do
        before_filter :check_settings_permissions
      
        private
        def check_settings_permissions
           render status: 403 unless current_user && can_manage_settings?(current_user)
        end
      end
    end 




This project uses MIT-LICENSE.
