class AddStoppedAtToPlay < ActiveRecord::Migration[6.1]
  def change
    add_column :plays, :stopped_at, :timestamp
  end
end
