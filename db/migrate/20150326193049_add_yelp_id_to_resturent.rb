class AddYelpIdToResturent < ActiveRecord::Migration
  def change
    add_column :resturents, :yelp_id, :string
  end
end
