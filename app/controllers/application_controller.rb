class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: Rails.application.config.synchronist_username, password: Rails.application.config.synchronist_password
end
