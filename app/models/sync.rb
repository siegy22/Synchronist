class Sync < ApplicationRecord
  after_update_commit -> { broadcast_replace_later_to "sync_detail_#{id}", partial: "syncs/sync_detail" }
  broadcasts inserts_by: :prepend

  has_one_attached :payload
  has_many :sent_files

  scope :ordered, -> { order(created_at: :desc) }

  def start!
    update(started_at: Time.now)
  end

  def finish!
    update(finished_at: Time.now)
  end

  def errored?
    errored_at
  end

  def succeeded?
    finished_at && errored_at.blank?
  end

  def finished?
    finished_at || errored_at
  end

  def duration
    return 0 if !started_at || !finished_at

    finished_at - started_at
  end
end
