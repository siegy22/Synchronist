module Sender
  class Watcher
    def self.start!(path, source_path, send_path)
      listener = Listen.to(File.dirname(path)) do |modified, added, removed|
        if File.file?(path)
          sync = Sync.create!
          sync.payload.attach(io: File.new(path), filename: File.basename(path))

          Sender::ProcessPayloadJob.perform_later(
            path.to_s,
            source_path.to_s,
            send_path.to_s,
            sync
          )
        end
      end
      listener.start
    end
  end
end
