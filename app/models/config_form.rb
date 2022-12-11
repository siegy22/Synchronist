class ConfigForm
  include ActiveModel::Model

  attr_accessor(:receiver_send_payload_cron, *Config::CONFIGS)
  validates :mode, presence: true
  validates :receiver_send_payload_cron, presence: true
  validates_presence_of(*Config::SENDER_CONFIGS, if: -> { mode == "sender" })
  validates_presence_of(*Config::RECEIVER_CONFIGS, if: -> { mode == "receiver" })
  validate :validate_cron

  def receiver_send_payload_cron
    @receiver_send_payload_cron || "0 */6 * * *"
  end

  def self.current
    new(Hash[Config.all.pluck(:name, :value)])
  end

  def save
    return false unless valid?

    Config.transaction do
      Config::CONFIGS.each do |attr|
        Config.set!(name: attr, value: public_send(attr))
      end

      Sidekiq::Cron::Job.destroy_all!
      if Config.configured? && mode == "sender"
        Sidekiq::Cron::Job.create(name: "Sender: Check payload ", cron: ENV.fetch("SYNCHRONIST_CHECK_PAYLOAD_CRON", "* * * * *"), class: Sender::CheckPayloadPathJob.to_s)
      elsif Config.configured? && mode == "receiver"
        Sidekiq::Cron::Job.create(name: "Receiver: Generate and send payload of current storage folder", cron: receiver_send_payload_cron, class: Receiver::SendPayloadJob.to_s)
        Sidekiq::Cron::Job.create(name: "Receiver: Check for received files and put them into storage folder", cron: ENV.fetch("SYNCHRONIST_CHECK_RECEIVED_FILES_CRON", "* * * * *"), class: Receiver::CheckReceiveFolderJob.to_s)
      end
    end
    true
  end

  def validate_cron
    if Fugit::Cron.parse(receiver_send_payload_cron).blank?
      errors.add(:receiver_send_payload_cron, "Invalid cron expression")
    end
  end
end
