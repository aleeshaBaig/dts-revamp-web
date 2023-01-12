class AddPermUcToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :perm_uc, :string
  end
end
