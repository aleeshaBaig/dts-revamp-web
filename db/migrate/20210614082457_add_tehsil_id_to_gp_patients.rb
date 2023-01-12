class AddTehsilIdToGpPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :gp_patients, :tehsil_id, :integer
  end
end
