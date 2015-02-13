class AddPlayersCountToGame < ActiveRecord::Migration
  def change
    add_column :games, :players_count, :integer
  end
end
