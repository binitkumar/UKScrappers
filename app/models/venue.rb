class Venue < ActiveRecord::Base
  has_many :venue_categories
  has_many :categories, through: :venue_categories
end
