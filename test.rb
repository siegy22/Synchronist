require 'fileutils'

def create_directories(base_path, depth, file_count)
  if depth == 0
    # Create the files at this level
    file_count.times do |i|
      File.write(File.join(base_path, "file_#{i}.txt"), "Content for file #{i}")
    end
    return
  end

  # Number of directories at this level
  dir_count = 5

  # Distribute files evenly across directories
  files_per_dir = file_count / dir_count

  dir_count.times do |i|
    dir_path = File.join(base_path, "dir_#{i}")
    FileUtils.mkdir_p(dir_path)
    create_directories(dir_path, depth - 1, files_per_dir)
  end
end

# Base path where the structure will be created
base_path = "./test/fixtures/files/benchmark"

# Depth of the directory structure
depth = 5

# Total number of files to create
total_files = 100000

# Create the directories and files
create_directories(base_path, depth, total_files)

puts "Directory structure created successfully."
