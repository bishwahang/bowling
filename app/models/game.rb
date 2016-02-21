class Game < ActiveRecord::Base
  has_many :frames, -> { order "created_at ASC" }

  def finished?
    return false if self.frames.count < 10
    return false if extra_frame?
    true
  end

  # if the 11th frame is required?
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

  # loops through the frames created so far
  # updates the score for strike and spare frame
  def update_score
    frames.take(10).each_with_index do |frame, index|
      # do not consider any frame that is already marked done
      # or the extra frame (11th frame)
      unless frame.mark || frame.extra_frame
        # for all frame besides the 10th frame
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
          # for the last frame (10th frame)
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
