class CreateHotspots < ActiveRecord::Migration[6.0]
  def change
    create_table :hotspots do |t|
      t.string :town
      t.string :uc
      t.string :address
      t.string :tag
      t.string :description
      t.string :name
      t.string :lat
      t.string :long
      t.integer :district_id
      t.string :district
      t.boolean :is_active
      t.integer :town_id
      t.integer :uc_id

      t.timestamps
    end
  end
end
