class AddColumnIsDpcToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :is_dpc, :boolean, default: false
    add_index :patients, :is_dpc
  end
end
