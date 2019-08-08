class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :online
      t.integer :won_count
      t.integer :lost_count
      t.integer :draw_count

      t.timestamps
    end
  end
end
