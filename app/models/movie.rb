class Movie < ActiveRecord::Base
  def self.all_ratings
    select(:rating).distinct.pluck(:rating)
  end
end
