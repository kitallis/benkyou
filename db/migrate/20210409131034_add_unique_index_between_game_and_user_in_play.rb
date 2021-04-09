class AddUniqueIndexBetweenGameAndUserInPlay < ActiveRecord::Migration[6.1]
  def change
    add_index :plays, [:game_id, :user_id], unique: true
  end
end
