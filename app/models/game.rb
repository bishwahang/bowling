class Game < ActiveRecord::Base
  has_many :frames
  validates :name, presence: true
  def finished?
    return false if self.frames.count < 10
    return false if extra_frame?
    true
  end

  def extra_frame?
    if self.frames.count == 10
      last_frame = frames.last
      return true if last_frame.is_strike? || last_frame.is_spare?
    end
    false
  end

  def final_score?
    update_score
    frames.take(10).map(&:score).inject(:+)
  end

  def update_score
    frames.each_with_index do |frame, index|
      unless frame.mark || frame.extra_frame
        if index < 9
          # if frame is strike check for two consequetive ball
          if frame.is_strike? && frames[index.succ]
            next_frame = frames[index.succ]
            if next_frame.is_strike?
              if frames[index.succ]
                next_frame = frames[index.succ]
                points = 20 + next_frame.first_roll
                frame.update_and_mark!(score: points)
              end
            else
              points = 10 + next_frame.total_score?
              frame.update_and_mark!(score: points)
            end
          end
          # if frame is spare check for one consequetive ball
          if frame.is_spare? && frames[index.succ]
            points = 10 + frames[index.succ].first_roll
            frame.update_and_mark!(score: points)
          end
        else
          if frames[index.succ]
            next_frame = frames[index.succ]
            points = 10 + next_frame.total_score?
            frame.update_and_mark!(score: points)
          end
        end
      end
    end
  end
end
