module Sender
  class Payload < ApplicationRecord
    include UIDPrimaryKey

    self.table_name_prefix = "sender_"

    has_one_attached :file
    broadcasts inserts_by: :prepend

    scope :ordered, -> { order(received_at: :desc) }
  end
end
