class AddColsToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :perm_house_no, :string
    add_column :lab_patients, :perm_street_no, :string
    add_column :lab_patients, :perm_locality, :string
    add_column :lab_patients, :perm_district_id, :integer
    add_column :lab_patients, :perm_tehsil_id, :integer
    add_column :lab_patients, :perm_uc_id, :integer
    add_column :lab_patients, :workplc_house_no, :string
    add_column :lab_patients, :workplc_street_no, :string
    add_column :lab_patients, :workplc_locality, :string
    add_column :lab_patients, :workplc_district_id, :integer
    add_column :lab_patients, :workplc_tehsil_id, :integer
    add_column :lab_patients, :workplc_uc_id, :integer
  end
end
