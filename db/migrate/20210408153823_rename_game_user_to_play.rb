class RenameGameUserToPlay < ActiveRecord::Migration[6.1]
  def change
    rename_table :game_users, :plays
    rename_column :answers, :game_user_id, :play_id
  end
end
