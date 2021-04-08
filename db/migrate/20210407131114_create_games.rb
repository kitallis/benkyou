class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :name
      t.string :status
      t.bigint :length

      t.timestamps
    end
  end
end
