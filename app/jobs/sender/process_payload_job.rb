module Sender
  # Puts all the missing and/or outdated files into the send folder.
  # E.g. if the payload says the following:
  #
  # <storage>/foo
  # └── 1.txt
  #
  # But the source currently is:
  # <source>/foo
  # ├── 1.txt
  # └── 2.txt
  #
  # It will put the difference into the send folder:
  #
  # <send>/foo
  # └── 2.txt
  class ProcessPayloadJob < ApplicationJob
    queue_as :default

    def perform(sync, source_path, target_path)
      sync.start!

      payload_files = sync.sender_payload.load[:files]
      files_to_send = Sender::Diff.diff(source_path, payload_files)
      Sender::Send.send(source_path, files_to_send, target_path, sync)

      sync.finish!
    rescue StandardError => e
      sync.update(errored_at: Time.now, error_message: e.full_message)
      raise e
    end
  end
end
