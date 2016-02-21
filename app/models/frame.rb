class Frame < ActiveRecord::Base
  belongs_to :game
  # attr_accessor :roll1, :roll2, :points, :strike, :spare
  # validates :first_roll, :second_roll, presence: true
  validates :first_roll, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }
  validates :second_roll, numericality: {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }
  validate :check_total_score
  before_create :process

  def check_total_score
    if total_score? > 10 || total_score? < 0
      errors.add(:base, "Total sum cannot be more than 10 or less than 0")
    end
  end

  def update_and_mark!(score: total_score?)
    self.score = score
    self.mark  = true
    save!
  end

  def process
    if is_strike?
      self.second_roll = nil
    end
    if !is_strike? && !is_spare?
      self.score = total_score?
      self.mark = true
    end
  end

  def is_strike?
    first_roll == 10
  end

  def is_spare?
    !is_strike? && total_score? == 10
  end

  def total_score?
    score = 0
    score += first_roll if first_roll
    score += second_roll if second_roll
    score
  end
end
