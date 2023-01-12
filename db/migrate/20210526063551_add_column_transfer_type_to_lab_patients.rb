class AddColumnTransferTypeToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :transfer_type, :integer, default: 0
    add_index :lab_patients, :transfer_type
  end
end
