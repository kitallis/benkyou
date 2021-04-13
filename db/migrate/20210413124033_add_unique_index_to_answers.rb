class AddUniqueIndexToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_index :answers, [:card_id, :play_id], unique: true
  end
end
