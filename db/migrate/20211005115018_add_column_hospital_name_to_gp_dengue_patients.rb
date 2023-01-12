class AddColumnHospitalNameToGpDenguePatients < ActiveRecord::Migration[6.0]
  def change
    add_column :gp_dengue_patients, :hospital_name, :string
  end
end
