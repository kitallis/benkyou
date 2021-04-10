class CreateGameUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :game_users do |t|
      t.timestamp :started_at
      t.string :status, null: false
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
