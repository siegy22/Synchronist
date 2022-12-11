module Receiver
  class StoreFileJob < ApplicationJob
    def perform(file_path)
      storage_folder = Config.get!(:receiver_storage_folder)
      unless File.directory?(storage_folder)
        return Rails.logger.warn("Storage folder is not a valid directory, please check your configuration")
      end

      ReceivedFile.create!(path: file_path, size: File.size(Config.get!(:receiver_receive_folder).join(file_path)))
      `rsync -Rt --remove-source-files #{File.join(Config.get!(:receiver_receive_folder), "/")}.#{File.join("/", file_path)} #{storage_folder}`
    end
  end
end
