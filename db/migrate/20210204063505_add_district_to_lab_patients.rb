class AddDistrictToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :district, :string
  end
end
