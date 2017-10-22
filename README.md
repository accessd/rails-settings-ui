Rails settings UI
================================

[![Gem Version](https://badge.fury.io/rb/rails-settings-ui.png)](http://badge.fury.io/rb/rails-settings-ui)
[![Build Status](https://travis-ci.org/accessd/rails-settings-ui.svg?branch=master)](https://travis-ci.org/accessd/rails-settings-ui)
[![Code Climate](https://codeclimate.com/github/accessd/rails-settings-ui/badges/gpa.svg)](https://codeclimate.com/github/accessd/rails-settings-ui)
[![Test Coverage](https://codeclimate.com/github/accessd/rails-settings-ui/badges/coverage.svg)](https://codeclimate.com/github/accessd/rails-settings-ui/coverage)

A Rails Engine to manage your application settings. Includes validation. Compatible with Rails 5.
It compatible with [rails-settings-cached](https://github.com/huacnlee/rails-settings-cached) gem.

Preview:

![ScreenShot](https://raw.github.com/accessd/rails-settings-ui/master/doc/img/settings-page.png)

Live example: http://rails-settings-ui.herokuapp.com/

How to
-----

Add to Gemfile

    gem 'rails-settings-ui'

then add

    gem 'rails-settings-cached'

or

    gem 'rails-settings'

or your fork of rails-settings.

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
        help_block: 'Rocket launch mode'
```

Validations
-------------

To validation work is required the default settings in the proper format, eg:

For rails-settings-cached up to 0.5.8:

    class Settings < RailsSettings::CachedSettings
      defaults[:company_name] = "Company name"
      defaults[:head_name] = "Head name"
      defaults[:manager_premium] = 19
      defaults[:show_contract_fields] = true
      defaults[:launch_mode] = [:auto, :manual]
    end

For rails-settings-cached with version >= 0.6.0 default settings moved to YAML config file (config/app.yml), so
defaults should looks like:

```yaml
  defaults: &defaults
    rocket_name: "Foo"
    limit: 123
    launch_mode:
      - auto
      - manual
    spaceports:
      - plesetsk
      - baikonur
    style:
      border_color: 'e0e0e0'
      block_color: 'ffffff'
      title:
        font: "Tahoma"
        size: "12"
        color: '107821'

  development:
    <<: *defaults

  test:
    <<: *defaults

  production:
    <<: *defaults
```

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
        before_filter :check_settings_permissions # for Rails 3
        before_action :check_settings_permissions # starting from Rails 4

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
