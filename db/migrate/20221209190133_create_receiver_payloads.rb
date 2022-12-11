class CreateReceiverPayloads < ActiveRecord::Migration[7.0]
  def change
    create_table :receiver_payloads do |t|
      t.string :uid, null: false
      t.datetime :sent_at, null: false

      t.timestamps
    end
  end
end
