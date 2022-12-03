require "test_helper"

class RoundTripTest < ActiveSupport::TestCase
  test "full round trip" do
    # Mark file.txt that is has been changed
    FileUtils.touch(Config.get!("sender_source_folder").join("round_trip/file.txt"))

    # Receiver: Generate payload and send it to sender
    Payload.generate(Config.get!("receiver_storage_folder").join("../round_trip_storage"), Config.get!("sender_payload_path"))

    # Sender: Parse payload, generate diff, send missing/outdated files
    Sender::ProcessPayloadJob.perform_now(
      File.new(Config.get!("sender_payload_path")),
      Config.get!("sender_source_folder").join("round_trip"),
      Config.get!("sender_send_folder"),
    )

    assert_file_list(["file.txt", "sub/2/2.txt"], Config.get!("sender_send_folder"))
    assert_includes File.read(Config.get!("sender_send_folder").join("file.txt")), "this is updated"
  end
end
