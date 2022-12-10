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

  def self.configured?
    return false if get!(:mode).blank?

    if sender?
      where(name: [:sender_payload_path, :sender_source_folder, :sender_send_folder]).pluck(:value).all?(&:present?)
    elsif get!(:mode) == "receiver"
      where(name: [:receiver_payload_path, :receiver_storage_folder, :receiver_receive_folder]).pluck(:value).all?(&:present?)
    end
  end

  def self.sender?
    get!(:mode) == "sender"
  end

  def self.receiver?
    get!(:mode) == "receiver"
  end

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
