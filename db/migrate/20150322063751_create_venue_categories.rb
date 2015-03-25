class CreateVenueCategories < ActiveRecord::Migration
  def change
    create_table :venue_categories do |t|
      t.integer :venue_id
      t.integer :category_id
      t.boolean :primary

      t.timestamps
    end
  end
end
