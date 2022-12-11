module Receiver
  class CheckReceiveFolderJob < ApplicationJob
    def perform
      folder = Config.get!(:receiver_receive_folder)
      unless File.directory?(folder)
        return Rails.logger.warn("Receive folder is not a valid directory, please check your configuration")
      end

      Dir.chdir(folder) do
        Dir.glob("**/*").select(&File.method(:file?)).each do |file|
          StoreFileJob.perform_later(file)
        end
      end
    end
  end
end
