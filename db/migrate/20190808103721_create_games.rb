class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :player_1
      t.integer :player_2
      t.integer :draw
      t.integer :winner
      t.string :state

      t.timestamps
    end
  end
end
