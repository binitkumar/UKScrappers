class CreateResturentGroups < ActiveRecord::Migration
  def change
    create_table :resturent_groups do |t|
      t.references :resturent, index: true
      t.references :group, index: true

      t.timestamps
    end
  end
end
