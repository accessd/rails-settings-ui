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
    # If you are using a custom layout, you will want to make app routes available to RailsSettingsUi:
    Rails.application.config.to_prepare { RailsSettingsUi.inline_main_app_routes! }






This project uses MIT-LICENSE.
