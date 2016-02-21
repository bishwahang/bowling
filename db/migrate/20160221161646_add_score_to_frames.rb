class AddScoreToFrames < ActiveRecord::Migration
  def change
    add_column :frames, :score, :Integer
  end
end
