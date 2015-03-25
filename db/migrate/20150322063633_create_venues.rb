class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :forsquare_id
      t.string :name
      t.string :phone
      t.string :twitter
      t.string :facebook
      t.string :facebook_name
      t.string :checkins_count
      t.string :tips_count
      t.string :users_count
      t.text :url
      t.string :store_id
      t.string :referal_id

      t.timestamps
    end
  end
end
