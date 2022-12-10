module Sender
  class CheckPayloadPathJob < ApplicationJob
    def perform
      if File.file?(payload_path) && (
           Sender::Payload.exists? ? File.mtime(payload_path) > Sender::Payload.ordered.first.mtime : true
         )
        Sender::ProcessPayloadJob.perform_later(
          Sender::Payload.receive!(payload_path),
          source_path.to_s,
          send_path.to_s,
        )
      end
    end

    private
    def payload_path
      payload_path ||= Config.get!(:sender_payload_path)
    end

    def source_path
      payload_path ||= Config.get!(:sender_source_folder)
    end

    def send_path
      payload_path ||= Config.get!(:sender_send_folder)
    end
  end
end
