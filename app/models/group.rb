class Group < ActiveRecord::Base
  has_many :resturent_groups
  has_many :resturents, through: :resturent_groups
end
