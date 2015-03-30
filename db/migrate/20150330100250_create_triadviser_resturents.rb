class CreateTriadviserResturents < ActiveRecord::Migration
  def change
    create_table :triadviser_resturents do |t|
      t.text :link

      t.timestamps
    end
  end
end
