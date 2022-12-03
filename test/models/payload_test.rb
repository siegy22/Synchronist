require "test_helper"

class PayloadTest < ActiveSupport::TestCase
  test "generate" do
    Payload.generate(Config.get!("receiver_storage_folder"), Config.get!("receiver_payload_path"))
    assert_equal [["1.txt", "2022-11-25 19:12:55 UTC"]], Marshal.load(File.read(Config.get!("receiver_payload_path")))
  end

  test "load" do
    PAYLOAD = ["test"].freeze
    tempfile = Tempfile.open do |f|
      f.write(Marshal.dump(PAYLOAD))
      f
    end
    assert_equal PAYLOAD, Payload.load(File.new(tempfile.path))
  end
end
