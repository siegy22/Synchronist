module Receiver
  class Payload < ApplicationRecord
    include UIDPrimaryKey

    self.table_name_prefix = "receiver_"

    has_one_attached :file
    # broadcasts inserts_by: :prepend

    scope :ordered, -> { order(sent_at: :desc) }

    def self.generate
      Marshal.dump(
        Dir.chdir(Config.get!(:receiver_storage_folder)) do
          Dir.glob("**/*").select(&File.method(:file?)).each_with_object([]) do |file, memo|
            memo << [file, File.mtime(file).utc.to_s]
            memo
          end
        end
      )
    end

    def self.send!
      payload_path = Config.get!(:receiver_payload_path)
      created = create(sent_at: Time.now)
      created.file.attach(
        io: StringIO.new(generate),
        filename: File.basename(payload_path)
      )

      File.write(payload_path, generate)
    end
  end
end
