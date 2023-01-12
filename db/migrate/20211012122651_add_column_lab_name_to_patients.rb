class AddColumnLabNameToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :lab_id, :integer
    add_column :patients, :lab_name, :string
  end
end
