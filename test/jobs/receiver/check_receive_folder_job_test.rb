require "test_helper"

class Receiver::CheckReceiveFolderJobTest < ActiveJob::TestCase
  test "check receive folder for things to receive" do
    File.write(Config.get!("receiver_receive_folder").join("sample.zip"), "this is a zip")
    File.write(Config.get!("receiver_receive_folder").join("sample.pdf"), "this is a pdf")

    assert_enqueued_jobs(2, only: Receiver::StoreFileJob) do
      Receiver::CheckReceiveFolderJob.perform_now
    end

    assert_difference -> { ReceivedFile.count }, +2 do
      perform_enqueued_jobs
    end

    assert_equal [], Dir.glob(Config.get!("receiver_receive_folder").join("**/*"))
  end
end
