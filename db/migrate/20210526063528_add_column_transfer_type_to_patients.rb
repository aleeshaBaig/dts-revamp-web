class AddColumnTransferTypeToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :transfer_type, :integer, default: 0
    add_index :patients, :transfer_type
  end
end
