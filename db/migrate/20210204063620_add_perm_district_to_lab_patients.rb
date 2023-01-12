class AddPermDistrictToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :perm_district, :string
  end
end
