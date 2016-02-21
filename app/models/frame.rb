class Frame < ActiveRecord::Base
  belongs_to :game
  # attr_accessor :roll1, :roll2, :points, :strike, :spare
  validates :first_roll, :second_roll, presence: true
  validates :first_roll, numericality: { only_integer: true, :greater_than_or_equal_to =>0, :less_than_or_equal_to =>10 }
  validates :second_roll, numericality: { only_integer: true , :greater_than_or_equal_to =>0, :less_than_or_equal_to =>10 }

  validate :total_points?
  def total_points?
    sum = 0
    sum += first_roll if first_roll
    sum += second_roll if second_roll
    if sum > 10
      errors.add(:base, "Total sum cannot be more thatn 10")
    end
  end

  def is_strike?
    first_roll == 10
  end

  def is_spare?
    points? == 10
  end

  def points?
    first_roll + second_roll
  end
end
