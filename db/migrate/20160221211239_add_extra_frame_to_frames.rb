class AddExtraFrameToFrames < ActiveRecord::Migration
  def change
    add_column :frames, :extra_frame, :Boolean
  end
end
