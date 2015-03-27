class AddCityToResturent < ActiveRecord::Migration
  def change
    add_column :resturents, :city, :string
  end
end
