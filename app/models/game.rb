class Game < ActiveRecord::Base
  has_many :frames
  validates :name, presence: true
  def finished?
    return false if self.frames.count < 10
    if self.frames.count == 10
      last_frame = self.frames[-1]
      return false if last_frame.is_strike? || last_frame.is_spare?
    end
    true
  end

  def total_score?
    frames.map(&:score).inject(:+)
  end

  def update_score
    frames.each_with_index do |frame, index|
    end
  end
end
