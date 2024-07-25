class Leaderboard < ApplicationRecord
  attr_accessor :rank

  self.primary_key = :user_id
  paginates_per 11

  def readonly?
    true
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[user_name score wins losses win_rate games_played seconds_played]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
