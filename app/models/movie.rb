class Movie < ActiveRecord::Base
  RATINGS = ['G','PG','PG-13','R']
  attr_accessible :title, :rating, :description, :release_date

  def self.ratings
    RATINGS
  end
end
