module Sender
  class Send
    def self.send(source_path, files, target_path, sync)
      Dir.chdir(source_path) do
        files_count = files.count
        sent_files = []
        progress_step = (1.0 / files_count * 100.0)
        progress = 0.0
        finish = Proc.new do |file|
          progress += progress_step
          sync.progress = progress.round
          sync.increment(:bytes_transferred, File.size(file))
          sync.save if sync.progress_changed?
        end
        sent_files = Parallel.map_with_index(files, finish: finish) do |file, index|
          `rsync -Rt #{file} #{target_path}`
          { path: file, size: File.size(file), sync_id: sync.id}
        end
        SentFile.insert_all(sent_files)
        sync.save
      end

      sync.increment(:progress, COPYING_PROGRESS) if files.empty?
    end
  end
end
