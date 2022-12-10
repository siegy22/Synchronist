module UIDPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :generate_uid
  end

  def generate_uid
    uid = SecureRandom.hex(6)
    return generate_uid if self.class.find_by(id: uid)
    self.id = uid
  end
end
