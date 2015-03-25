class AddGoogleIdToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :google_id, :string
  end
end
