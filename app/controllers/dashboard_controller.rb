class DashboardController < ApplicationController
  def index
    if Config.sender?
      @disk_usage = DiskUsage.size(Config.get!(:sender_source_folder))
      @bytes_sent = SentFile.sum(:size)
      @files_sent = SentFile.count
      @latest_syncs = Sync.ordered.limit(5)
      @latest_payloads = Sender::Payload.ordered.limit(5)
      render "sender/dashboard"
    else
      @disk_usage = DiskUsage.size(Config.get!(:receiver_storage_folder))
      @files_received = ReceivedFile.count
      @bytes_received = ReceivedFile.sum(:size)
      @sync_cron = Config.get!(:receiver_send_payload_cron)
      @latest_received_files = ReceivedFile.ordered.limit(5)
      @latest_payloads = Receiver::Payload.ordered.limit(5)
      render "receiver/dashboard"
    end
  end
end
