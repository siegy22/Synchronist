class Config < ApplicationRecord
  CONFIGS = [
    :mode,
    :sender_payload_path,
    :sender_source_folder,
    :sender_send_folder,
    :receiver_payload_path,
    :receiver_storage_folder,
    :receiver_receive_folder
  ].freeze

  def self.get!(name)
    value = find_by!(name: name).value

    if name.end_with?("_folder")
      Pathname.new(value)
    else
      value
    end
  end

  def self.set!(name:, value:)
    Config.find_by!(name: name).update(value: value)
  end
end
