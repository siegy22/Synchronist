require "test_helper"

class ProcessPayloadJobTest < ActiveJob::TestCase
  test "add 2.txt" do
    Sender::ProcessPayloadJob.perform_now(
      sync_with_payload({ "1.txt" => BASE_MTIME_TIMESTAMP }),
      Config.get!("sender_source_folder").join("simple_add"),
      Config.get!("sender_send_folder"),
    )

    assert_file_list(["2.txt"], Config.get!("sender_send_folder"))
  end

  test "outdated mtime - replace file" do
    Sender::ProcessPayloadJob.perform_now(
      sync_with_payload({ "1.txt" => OUTDATED_MTIME_TIMESTAMP }),
      Config.get!("sender_source_folder").join("mtime_replace"),
      Config.get!("sender_send_folder"),
    )

    assert_file_list(["1.txt"], Config.get!("sender_send_folder"))
  end

  test "add/replace with subdirectories" do
    Sender::ProcessPayloadJob.perform_now(
      sync_with_payload(
        {
          "sub/1/1.txt" => BASE_MTIME_TIMESTAMP,
          "sub/2/2.txt" => OUTDATED_MTIME_TIMESTAMP,
        }),
      Config.get!("sender_source_folder").join("with_subdirectories"),
      Config.get!("sender_send_folder"),
    )

    assert_file_list(["other/3/3.txt", "sub/2/2.txt"], Config.get!("sender_send_folder"))
  end

  test "sync bytes transferred and progress" do
    payload = {
      "sub/1/1.txt" => BASE_MTIME_TIMESTAMP,
      "sub/2/2.txt" =>  OUTDATED_MTIME_TIMESTAMP,
    }

    Sender::ProcessPayloadJob.perform_now(
      (sync = sync_with_payload(payload)),
      Config.get!("sender_source_folder").join("with_subdirectories"),
      Config.get!("sender_send_folder"),
    )

    assert_equal(100, sync.progress)
    assert_equal(12, sync.bytes_transferred)
    assert_equal({ uid: :testing, files: payload }, Marshal.load(sync.sender_payload.file.download))
  end

  def generate_readable_payload(obj)
    StringIO.new(Marshal.dump(obj))
  end

  def sync_with_payload(payload)
    sender_payload = Sender::Payload.create!(received_at: Time.now, mtime: Time.now, uid: :testing)
    sender_payload.file.attach(io: generate_readable_payload({ uid: :testing, files: payload}), filename: "payload.sync")
    Sync.create!(sender_payload: sender_payload)
  end
end
