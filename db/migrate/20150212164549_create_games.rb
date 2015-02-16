class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :board
      t.integer :turn_count
      t.integer :player1_id
      t.integer :player2_id
      t.integer :num_contestants
      t.string :player1_email
      t.string :player2_email

      t.timestamps null: false
    end
  end
end
