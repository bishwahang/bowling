class AddNameToGames < ActiveRecord::Migration
  def change
    add_column :games, :name, :Text
  end
end
