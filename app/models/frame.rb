class Frame < ActiveRecord::Base
  belongs_to :game
  # attr_accessor :roll1, :roll2, :points, :strike, :spare
  # validates :first_roll, :second_roll, presence: true
  validates :first_roll, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }
  validates :second_roll, numericality: {:allow_blank => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10 }
  validate :check_total_score
  before_create :process

  def check_total_score
    if extra_frame
      if (total_score? > 20 || total_score? < 0)
        errors.add(:base, "Total sum cannot be more than 20 or less than 0")
      end
    else
      if total_score? > 10 || total_score? < 0
        errors.add(:base, "Total sum cannot be more than 10 or less than 0")
      end
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
    if (!is_strike? && !is_spare?) || extra_frame
      self.score = total_score?
      self.mark = true
    end
  end

  def is_strike?
    return false if extra_frame
    first_roll == 10 && (second_roll.nil? || second_roll == 0)
  end

  def is_spare?
    return false if extra_frame
    !is_strike? && total_score? == 10
  end

  def total_score?
    score = 0
    score += first_roll if first_roll
    score += second_roll if second_roll
    score
  end
end
