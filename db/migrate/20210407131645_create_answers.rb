class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :attempt
      t.boolean :correct
      t.references :card, null: false, foreign_key: true
      t.references :game_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
