class AddWorkplcUcToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :workplc_uc, :string
  end
end
