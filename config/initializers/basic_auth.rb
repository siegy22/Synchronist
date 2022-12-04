if Rails.env.production?
  Rails.application.config.synchronist_username = ENV.fetch("SYNCHRONIST_USERNAME")
  Rails.application.config.synchronist_password = ENV.fetch("SYNCHRONIST_PASSWORD")
else
  Rails.application.config.synchronist_username = "sync"
  Rails.application.config.synchronist_password = "sync"
end
