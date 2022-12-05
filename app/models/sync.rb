class Sync < ApplicationRecord
  has_one_attached :payload

  def start
    update(started_at: Time.now)
  end

  def finish
    update(finished_at: Time.now)
  end
end
