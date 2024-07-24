class Leaderboard < ApplicationRecord
  attr_accessor :rank

  self.primary_key = :user_id
  paginates_per 11

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

  def self.ransackable_attributes(auth_object = nil)
    %w[user_name score wins losses win_rate games_played seconds_played]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
