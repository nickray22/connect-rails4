class MakeFinishedDefaultFalseOnGames < ActiveRecord::Migration
  def up
    Game.find_each do |g|
      g.update_attribute :finished, false
    end

    change_column :games, :finished, :boolean, :default => false, :null => false
  end

  def down
    change_column :games, :finished, :boolean
  end
end
