class AddFirstRollAndSecondRollToFrames < ActiveRecord::Migration
  def change
    add_column :frames, :first_roll, :Integer
    add_column :frames, :second_roll, :Integer
  end
end
