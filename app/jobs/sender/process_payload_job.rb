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

    PAYLOAD_LOAD_PROGRESS = 10.0
    DIFF_PROGRESS = 40.0
    COPYING_PROGRESS = 50.0

    def perform(sync, source_path, target_path)
      sync.start!

      payload_files = sync.sender_payload.load[:files]
      sync.increment(:progress, PAYLOAD_LOAD_PROGRESS)
      sync.save

      Dir.chdir(source_path) do
        source_files = Dir.glob("**/*").select(&File.method(:file?))
        source_files_count = source_files.count
        files_to_copy = source_files.each_with_object([]) do |file, memo|
          sync.increment(:progress, (1.0 / source_files_count * DIFF_PROGRESS))
          sync.save

          memo << file if !payload_files.key?(file) || payload_files[file] < File.mtime(file).to_i
          memo
        end

        files_to_copy_count = files_to_copy.count
        files_to_copy.each do |file|
          `rsync -Rt #{file} #{target_path}`
          file_size = File.size(file)
          sync.increment(:bytes_transferred, file_size)

          sync.increment(:progress, (1.0 / files_to_copy_count * COPYING_PROGRESS))
          sync.sent_files.create(path: file, size: file_size)
          sync.save
        end
      end

      sync.finish!
    rescue StandardError => e
      sync.update(errored_at: Time.now, error_message: e.full_message)
      raise e
    end
  end
end
