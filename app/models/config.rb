class Config < ApplicationRecord
  SENDER_CONFIGS = [
    :sender_payload_path,
    :sender_source_folder,
    :sender_send_folder,
  ]

  RECEIVER_CONFIGS = [
    :receiver_relay_mode,
    :receiver_send_payload_cron,
    :receiver_payload_path,
    :receiver_storage_folder,
    :receiver_receive_folder,
  ]

  RELAY_CONFIGS = [
    :receiver_relay_folder,
  ]

  CONFIGS = [
    :mode,
    *SENDER_CONFIGS,
    *RECEIVER_CONFIGS,
    *RELAY_CONFIGS,
  ].freeze

  def self.configured?
    return false if get!(:mode).blank?

    case
    when sender?
      where(name: SENDER_CONFIGS).pluck(:value).all?(&:present?)
    when receiver? && relay?
      where(name: RECEIVER_CONFIGS + RELAY_CONFIGS).pluck(:value).all?(&:present?)
    when receiver?
      where(name: RECEIVER_CONFIGS).pluck(:value).all?(&:present?)
    end
  end

  def self.sender?
    get!(:mode) == "sender"
  end

  def self.receiver?
    get!(:mode) == "receiver"
  end

  def self.relay?
    get!(:receiver_relay_mode) == "1"
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
