module RailsSettingsUi
  class ApplicationController < ::RailsSettingsUi.parent_controller.constantize

    def current_user
      @current_user
    end

  end
end
