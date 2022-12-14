class ChangeFileSizesToBigint < ActiveRecord::Migration[7.0]
  def change
    change_column :sent_files, :size, :bigint, default: 0
    change_column :received_files, :size, :bigint, default: 0
  end
end
