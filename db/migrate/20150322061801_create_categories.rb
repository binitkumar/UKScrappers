class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :forsquare_id
      t.string :string
      t.string :name

      t.timestamps
    end
  end
end
