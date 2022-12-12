class DiskUsage
  def self.size(path)
    return 0 unless File.directory?(path)

    `du -sb #{path}`.to_i
  end
end
