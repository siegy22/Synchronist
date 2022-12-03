class Payload
  def self.generate(storage_path, output_file_path)
    output = Dir.chdir(storage_path) do
      Dir.glob("**/*").select(&File.method(:file?)).each_with_object([]) do |file, memo|
        memo << [file, File.mtime(file).utc.to_s]
        memo
      end
    end
    File.write(output_file_path, Marshal.dump(output))
  end

  def self.load(io)
    Marshal.load(io.read)
  end
end
