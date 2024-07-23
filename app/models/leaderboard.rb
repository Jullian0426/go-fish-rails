class Leaderboard < ApplicationRecord
  self.primary_key = :user_id

  def readonly?
    true
  end

  def formatted_time
    if seconds_played >= 3600
      hours = (seconds_played / 3600).to_i
      minutes = ((seconds_played % 3600) / 60).to_i
      "#{hours}h:#{minutes}m"
    elsif seconds_played >= 60
      minutes = (seconds_played / 60).to_i
      remaining_seconds = (seconds_played % 60).to_i
      "#{minutes}m:#{remaining_seconds}s"
    else
      "#{seconds_played.to_i}s"
    end
  end
end
