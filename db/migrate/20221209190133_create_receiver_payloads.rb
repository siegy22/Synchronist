class CreateReceiverPayloads < ActiveRecord::Migration[7.0]
  def change
    create_table :receiver_payloads, id: :string do |t|
      t.datetime :sent_at, null: false

      t.timestamps
    end
  end
end
