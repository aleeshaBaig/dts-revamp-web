class AddDistrictIdToGpPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :gp_patients, :district_id, :integer
  end
end
