class AddErroredAtToSyncs < ActiveRecord::Migration[7.0]
  def change
    add_column :syncs, :errored_at, :datetime
    add_column :syncs, :error_message, :string
  end
end
