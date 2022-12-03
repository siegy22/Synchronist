require "test_helper"

class WatcherTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "watches the payload path and queues a job" do
    Sender::Watcher.start!(
      Config.get!(:sender_payload_path),
      Config.get!(:sender_source_folder),
      Config.get!(:sender_send_folder),
    )

    assert_enqueued_with(job: Sender::ProcessPayloadJob) do
      # Sleeps are needed for the listen worker to be fully booted and also react to file changes
      sleep 0.5
      File.write(Config.get!(:sender_payload_path), Marshal.dump([["sample.txt", BASE_MTIME_STR]]))
      sleep 0.5
    end
  end
end
