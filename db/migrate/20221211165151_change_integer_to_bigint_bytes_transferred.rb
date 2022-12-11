class ChangeIntegerToBigintBytesTransferred < ActiveRecord::Migration[7.0]
  def change
    change_column :syncs, :bytes_transferred, :bigint, default: 0
  end
end
