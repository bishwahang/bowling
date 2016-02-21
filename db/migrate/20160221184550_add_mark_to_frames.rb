class AddMarkToFrames < ActiveRecord::Migration
  def change
    add_column :frames, :mark, :Boolean
  end
end
