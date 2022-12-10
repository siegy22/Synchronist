class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: Rails.application.config.synchronist_username, password: Rails.application.config.synchronist_password

  before_action :check_configuration

  private
  def check_configuration
    return if Config.configured?

    redirect_to edit_config_path, alert: "Configuration is incomplete; Please configure accordingly"
  end
end
