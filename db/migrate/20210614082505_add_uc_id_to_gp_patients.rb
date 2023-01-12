class AddUcIdToGpPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :gp_patients, :uc_id, :integer
  end
end
