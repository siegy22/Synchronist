ENV["RAILS_ENV"] ||= "test"
# XXX: Use database 2, by default sidekiq will use 0.
# This prevents Sidekiq::Cron::Jobs from being changed in dev when running tests.
ENV["REDIS_URL"] = "redis://localhost:6379/2"
require_relative "../config/environment"
require "rails/test_help"
require "sidekiq/testing"

Sidekiq.logger.level = Logger::WARN

class ActiveSupport::TestCase
  # Disable parallel tests because they're mostly based on files
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  OUTDATED_MTIME = Time.parse("1990-01-01 13:00:00 UTC")
  OUTDATED_MTIME_TIMESTAMP = OUTDATED_MTIME.to_i
  BASE_MTIME = Time.parse("2022-11-01 13:00:00 UTC")
  BASE_MTIME_TIMESTAMP = BASE_MTIME.to_i

  setup do
    Dir.glob(Config.get!("sender_source_folder").join("**/*")) do |file|
      FileUtils.touch(file, mtime: BASE_MTIME)
    end

    Dir.glob(Config.get!("receiver_storage_folder").join("**/*")) do |file|
      FileUtils.touch(file, mtime: BASE_MTIME)
    end
    FileUtils.rm_f(Config.get!("receiver_payload_path"))
    FileUtils.rm_f(Config.get!("sender_payload_path"))
    FileUtils.rm_rf(Config.get!("sender_send_folder"))
    FileUtils.mkdir_p(Config.get!("sender_send_folder"))
    FileUtils.rm_rf(Config.get!("receiver_receive_folder"))
    FileUtils.mkdir_p(Config.get!("receiver_receive_folder"))
    FileUtils.rm_rf Dir.glob(Config.get!("receiver_storage_folder").join('**/*')).reject { |f| File.basename(f) == "1.txt" }

    Sidekiq::Cron::Job.destroy_all!
  end

  def assert_file_list(expected, dir)
    Dir.chdir(dir) do
      assert_equal(expected, Dir.glob("**/*").select(&File.method(:file?)))
    end
  end
end
