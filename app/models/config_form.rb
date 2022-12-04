class ConfigForm
  include ActiveModel::Model

  attr_accessor(*Config::CONFIGS)
  validates :mode, presence: true

  def self.current
    new(Hash[Config.all.pluck(:name, :value)])
  end

  def save
    Config.transaction do
      Config::CONFIGS.each do |attr|
        Config.set!(name: attr, value: public_send(attr))
      end
    end
  end
end
