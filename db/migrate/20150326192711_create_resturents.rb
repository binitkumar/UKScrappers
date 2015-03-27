class CreateResturents < ActiveRecord::Migration
  def change
    create_table :resturents do |t|
      t.string :rating
      t.string :name
      t.string :phone
      t.string :postal_code
      t.string :address
      t.string :country
      t.string :state_code
      t.string :lat
      t.string :long
      t.text :address

      t.timestamps
    end
  end
end
