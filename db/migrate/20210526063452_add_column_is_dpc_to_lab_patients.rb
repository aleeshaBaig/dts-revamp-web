class AddColumnIsDpcToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :is_dpc, :boolean, default: false
    add_index :lab_patients, :is_dpc
  end
end
