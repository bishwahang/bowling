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

  def final_score?
    frames.map(&:score).inject(:+)
  end

  def update_score
    frames.each_with_index do |frame, index|
      unless frame.mark
        if index < 9
          # if frame is strike check for two consequetive ball
          if frame.is_strike? && frames[index.succ]
            next_frame = frames[index.succ]
            if next_frame.is_strike?
              if frames[index.succ]
                next_frame = frames[index.succ]
                points = 20 + next_frame.first_roll
                frame.update_and_mark! points
              end
            else
              points = 10 + next_frame.total_score?
              frame.update_and_mark! points
            end
          end
          if frame.is_spare? && frames[index.succ]
            points = 10 + frames[index.succ].first_roll
            frame.update_and_mark! points
          end
        else
          if frames[index.succ]
            next_frame = frames[index.succ]
            points = 10 + next_frame.total_score?
          end
        end
      end
    end
  end

  private
  def next_frame(index)
    frames[index+1]
  end
end
