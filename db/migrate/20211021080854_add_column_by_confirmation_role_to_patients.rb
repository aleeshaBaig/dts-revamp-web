class AddColumnByConfirmationRoleToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :confirmation_role, :integer
  end
end
