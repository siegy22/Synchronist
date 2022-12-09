class CreateSentFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :sent_files do |t|
      t.string :path, null: false
      t.integer :size, default: 0
      t.belongs_to :sync, foreign_key: true

      t.timestamps
    end
  end
end
