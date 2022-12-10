module Receiver
  class Payload < ApplicationRecord
    include UIDPrimaryKey

    self.table_name_prefix = "receiver_"

    has_one_attached :file
    broadcasts inserts_by: :prepend

    scope :ordered, -> { order(sent_at: :desc) }
  end
end
