class RemoveStrongReferencesFromEphemeralTables < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :answers, :cards
    remove_foreign_key :game_decks, :decks
  end
end
