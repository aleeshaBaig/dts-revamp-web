class AddWorkplcDistrictToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :workplc_district, :string
  end
end
