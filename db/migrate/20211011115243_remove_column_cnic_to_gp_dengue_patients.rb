class RemoveColumnCnicToGpDenguePatients < ActiveRecord::Migration[6.0]
  def change
    remove_column :gp_dengue_patients, :cnic
    add_column :gp_dengue_patients, :cnic, :string
  end
end
