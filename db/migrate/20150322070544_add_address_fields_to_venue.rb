class AddAddressFieldsToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :address, :string
    add_column :venues, :lat, :string
    add_column :venues, :lang, :string
    add_column :venues, :distance, :string
    add_column :venues, :postal_code, :string
    add_column :venues, :cc, :string
    add_column :venues, :city, :string
    add_column :venues, :state, :string
    add_column :venues, :country, :string
  end
end
