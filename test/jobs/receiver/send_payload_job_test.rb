require "test_helper"

class Receiver::SendPayloadJobTest < ActiveJob::TestCase
  test "send payload with job" do
    Receiver::SendPayloadJob.perform_now

    assert File.file?(Config.get!(:receiver_payload_path))
    assert_equal(
      { uid: "testing", files: [["1.txt", BASE_MTIME_STR]] },
      Marshal.load(File.read(Config.get!(:receiver_payload_path)))
    )
  end
end
