class AddColumnLabUserIdToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :lab_user_id, :integer
    add_index :patients, :lab_user_id
    add_column :patients, :lab_user_name, :string
    add_column :patients, :updated_id, :integer
  end
end
