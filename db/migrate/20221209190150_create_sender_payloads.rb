class CreateSenderPayloads < ActiveRecord::Migration[7.0]
  def change
    create_table :sender_payloads, id: :string do |t|
      t.datetime :received_at, null: false

      t.timestamps
    end
  end
end
