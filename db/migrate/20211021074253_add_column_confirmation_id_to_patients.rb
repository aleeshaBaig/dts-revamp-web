class AddColumnConfirmationIdToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :confirmation_id, :integer
    add_index :patients, :confirmation_id
  end
end
