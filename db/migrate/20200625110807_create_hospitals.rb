class CreateHospitals < ActiveRecord::Migration[6.0]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.integer :district_id
      t.string :facility_type
      t.string :category

      t.timestamps
    end
  end
end
