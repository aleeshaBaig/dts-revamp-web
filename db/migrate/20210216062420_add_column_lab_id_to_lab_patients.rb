class AddColumnLabIdToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :lab_id, :integer
    add_index :lab_patients, :lab_id
  end
end
