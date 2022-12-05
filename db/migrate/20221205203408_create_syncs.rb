class CreateSyncs < ActiveRecord::Migration[7.0]
  def change
    create_table :syncs do |t|
      t.float :progress, default: 0
      t.integer :bytes_transferred, default: 0
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
