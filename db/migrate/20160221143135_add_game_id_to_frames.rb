class AddGameIdToFrames < ActiveRecord::Migration
  def change
    add_column :frames, :game_id, :Integer
  end
end
