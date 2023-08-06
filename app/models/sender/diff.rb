module Sender
  class Diff
    def self.diff(source_path, payload_files)
      Dir.chdir(source_path) do
        source_files = Dir.glob("**/*").select(&File.method(:file?))

        source_files.each_with_object([]) do |file, memo|
          memo << file if !payload_files.key?(file) || payload_files[file] < File.mtime(file).to_i
          memo
        end
      end
    end
  end
end
