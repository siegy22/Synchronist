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

    def perform(payload_io, source_path, target_path)
      payload = Payload.load(payload_io)
      Dir.chdir(source_path) do
        files_to_copy = Dir.glob("**/*").select(&File.method(:file?)).each_with_object([]) do |file, memo|
          memo << file unless payload.include?([file, File.mtime(file).utc.to_s])
          memo
        end

        IO.popen(["rsync", "-RhvPt", *files_to_copy, target_path.to_s]) do |io|
          Rails.logger.info(io.gets)
        end
      end
    end
  end
end
