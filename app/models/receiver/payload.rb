module Receiver
  class Payload < ApplicationRecord
    self.table_name_prefix = "receiver_"

    has_one_attached :file
    broadcasts inserts_by: :prepend

    validates :sent_at, presence: true
    scope :ordered, -> { order(sent_at: :desc) }
    before_create :generate_uid

    def self.generate(uid, path: Config.get!(:receiver_storage_folder))
      files = Dir.chdir(path) do
        Dir.glob("**/*").select(&File.method(:file?)).each_with_object({}) do |file, memo|
          memo[file] = File.mtime(file).to_i
          memo
        end
      end

      Marshal.dump(
        {
          uid: uid,
          files: files,
        }
      )
    end

    def self.send!
      payload_path = Config.get!(:receiver_payload_path)
      created = create!(sent_at: Time.now)

      File.write(payload_path, generate(created.uid), mode: "wb")
      File.open(payload_path, "r") do |f|
        created.file.attach(
          io: f,
          filename: File.basename(payload_path)
        )
      end
    end

    def generate_uid
      if Rails.env.test?
        self.uid = :testing
      else
        self.uid = SecureRandom.hex(6)
      end
    end
  end
end
