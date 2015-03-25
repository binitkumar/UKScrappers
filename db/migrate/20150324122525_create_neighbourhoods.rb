class CreateNeighbourhoods < ActiveRecord::Migration
  def change
    create_table :neighbourhoods do |t|
      t.string :name
      t.string :latitude
      t.string :longitude
      t.string :status

      t.timestamps
    end
  end
end
