class RenameGameUserToPlayer < ActiveRecord::Migration[6.1]
  def change
    rename_table :game_users, :players
    rename_column :answers, :game_user_id, :player_id
  end
end
