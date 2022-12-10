require "test_helper"

class RoundTripTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    FileUtils.touch(Config.get!("sender_source_folder").join("round_trip/file.txt"), mtime: Time.now)
    FileUtils.touch(Config.get!("receiver_storage_folder").join("../round_trip_storage/file.txt"), mtime: 1.day.ago.utc)

    Config.set!(name: "receiver_storage_folder", value: Config.get!("receiver_storage_folder").join("../round_trip_storage"))
    Config.set!(name: "sender_source_folder", value: Config.get!("sender_source_folder").join("round_trip"))
  end

  test "full round trip" do
    # Receiver: Generate payload and send it to sender
    Receiver::Payload.send!

    # Faking the systems that are in between the sender and receiver
    FileUtils.mv(Config.get!(:receiver_payload_path), Config.get!("sender_payload_path"))

    # Fake cronjob that checks the payload file for changes
    assert_enqueued_with(job: Sender::ProcessPayloadJob) do
      Sender::CheckPayloadPathJob.perform_now
    end

    # Fake queue workers
    perform_enqueued_jobs

    assert_file_list(["file.txt", "sub/2/2.txt"], Config.get!("sender_send_folder"))
    assert_includes File.read(Config.get!("sender_send_folder").join("file.txt")), "this is updated"
  end
end
