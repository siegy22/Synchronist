class CreateSenderPayloads < ActiveRecord::Migration[7.0]
  def change
    create_table :sender_payloads do |t|
      t.string :uid, null: false
      t.datetime :received_at, null: false
      t.datetime :mtime, null: false

      t.timestamps
    end
  end
end
