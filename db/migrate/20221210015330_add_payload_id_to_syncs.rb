class AddPayloadIdToSyncs < ActiveRecord::Migration[7.0]
  def change
    add_column :syncs, :sender_payload_id, :bigint, null: false

    add_foreign_key :syncs, :sender_payloads
  end
end
