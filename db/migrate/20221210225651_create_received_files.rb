class CreateReceivedFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :received_files do |t|
      t.string :path, null: false
      t.integer :size, default: 0

      t.timestamps
    end
  end
end
