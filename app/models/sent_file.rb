class SentFile < ApplicationRecord
  belongs_to :sync

  scope :ordered, -> { order(:path) }
end
