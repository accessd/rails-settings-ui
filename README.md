Rails settings UI
================================

[![Gem Version](https://badge.fury.io/rb/rails-settings-ui.svg)](https://rubygems.org/gems/rails-settings-ui)
[![build](https://github.com/accessd/rails-settings-ui/workflows/build/badge.svg)](https://github.com/accessd/rails-settings-cached/actions?query=workflow%3Abuild)

A Rails Engine to manage your application settings. Includes validation. Compatible with Rails 8.
It depends on [rails-settings-cached](https://github.com/huacnlee/rails-settings-cached) gem.

Preview:

![ScreenShot](https://raw.github.com/accessd/rails-settings-ui/master/doc/img/settings-page.png)

How to
-----

Add to Gemfile

    gem 'rails-settings-ui'

If you want to use bootstrap interface you need also include bootstrap stylesheets to your app.
You may use [bootstrap-sass](https://github.com/twbs/bootstrap-sass) gem for that.

Setup:

    # adds initializer and route:
    rails g rails_settings_ui:install

Config
------------

In config/initializers/rails_settings_ui.rb

    RailsSettingsUi.setup do |config|
      config.ignored_settings = [:company_name] # Settings not displayed in the interface
      config.settings_class = "MySettings" # Customize settings class name
      config.settings_displayed_as_select_tag = [:mode] # Settings displayed as select tag instead of checkbox group field
      config.defaults_for_settings = {mode: :manual} # Default option values for select tags
      config.engine_name = "your engine name" # Default use 'main_app', if you mount this engine to another engine, then set name of engine
    end

Routing
-------

    # engine root:
    rails_settings_ui_url

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

*  Checkbox options labels for array options, eg:

```yaml
  settings:
    attributes:
      launch_mode:
        labels:
          auto: 'Auto mode'
          manual: 'Manual mode'
```

*  Select options labels and values, eg:

```yaml
  settings:
    attributes:
      buy_mode:
        labels:
          auto: 'Auto buy' # 'auto' is option value, 'Auto buy' is option label
          manual: 'Manual buy'
```

so result will be:

```html
  <option value="auto">Auto buy</option>
  <option value="manual">Manual buy</option>
```

if you don't specify labels in locale config, you'll get:

```html
  <option value="auto">auto</option>
  <option value="manual">manual</option>
```

*  Help blocks for settings, eg:

```yaml
  settings:
    attributes:
      launch_mode:
        help_block: 'launch mode'
```

Validations
-------------

Validations work based on default value for setting or by explicitly specify type for setting, eg:

    class Settings < RailsSettings::Base
      cache_prefix { "v1" }

      field :company_name, type: :string, default: "Company name"
      field :head_name, default: "Head name"
      field :manager_premium, default: 19
      field :show_contract_fields, default: true
      field :launch_mode, default: [:auto, :manual]
    end

Views
-------------

Default layout is `application`, but you can render all rails-settings-ui views inside your app layout
(for nice looking you will need include bootstrap, eg: `@import 'bootstrap';` in your applications.css.scss):

    Rails.application.config.to_prepare do
      # Use admin layout:
      RailsSettingsUi::ApplicationController.module_eval do
        layout 'admin'
      end
      # If you are using a custom layout, you will want to make app routes available to rails-setting-ui:
      RailsSettingsUi.inline_engine_routes! # old name of method inline_main_app_routes!
    end


Authentication & authorization
------------------------------

You can specify the parent controller for settings controller, and it will inherit all before filters.
Note that this must be placed before any other references to rails-setting-ui application controller in the initializer:

    RailsSettingsUi.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'

Alternatively, to have custom rules just for rails-setting-ui you can:

    Rails.application.config.to_prepare do
      RailsSettingsUi::ApplicationController.module_eval do
        before_action :check_settings_permissions

        private

        def check_settings_permissions
          render status: 403 unless current_user && can_manage_settings?(current_user)
        end
      end
    end

Issues
-------------

  * If you wish to use route helpers for your app in parent controllers of `RailsSettingsUi::ApplicationController`, you must call helpers for `main_app`, for example: `main_app.root_path`


This project uses MIT-LICENSE.
