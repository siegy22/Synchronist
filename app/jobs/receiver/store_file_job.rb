module Receiver
  class StoreFileJob < ApplicationJob
    def perform(file_path)
      storage_folder = Config.get!(:receiver_storage_folder)
      unless File.directory?(storage_folder)
        return Rails.logger.warn("Storage folder is not a valid directory, please check your configuration")
      end

      Dir.chdir(Config.get!(:receiver_receive_folder)) do
        ReceivedFile.create!(path: file_path, size: File.size(file_path))
        `rsync -Rt --remove-source-files #{file_path} #{storage_folder}`
      end
    end
  end
end
