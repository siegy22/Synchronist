ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Disable parallel tests because they're mostly based on files
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  OUTDATED_MTIME = Time.parse("1990-01-01 13:00:00 UTC")
  OUTDATED_MTIME_STR = OUTDATED_MTIME.utc.to_s
  BASE_MTIME = Time.parse("2022-11-01 13:00:00 UTC")
  BASE_MTIME_STR = BASE_MTIME.utc.to_s

  setup do
    Dir.glob(Config.get!("sender_source_folder").join("**/*")) do |file|
      FileUtils.touch(file, mtime: BASE_MTIME)
    end
    FileUtils.rm_f(Config.get!("receiver_payload_path"))
    FileUtils.rm_rf(Config.get!("sender_send_folder"))
    FileUtils.rm_f(Config.get!("sender_payload_path"))
    FileUtils.mkdir_p(Config.get!("sender_send_folder"))
  end

  def assert_file_list(expected, dir)
    Dir.chdir(dir) do
      assert_equal(expected, Dir.glob("**/*").select(&File.method(:file?)))
    end
  end
end
