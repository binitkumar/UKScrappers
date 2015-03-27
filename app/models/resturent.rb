class Resturent < ActiveRecord::Base
  has_many :resturent_groups
  has_many :groups, through: :resturent_groups

  reverse_geocoded_by :lat, :long do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.state_code   = geo.state
    end
  end
  after_validation :reverse_geocode
end
