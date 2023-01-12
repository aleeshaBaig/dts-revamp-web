class AddProvinceIdToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :province_id, :integer
    add_column :hospitals, :province_id, :integer
    add_column :gp_patients, :province_id, :integer
  end
end
