class AddIsTaggedToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :residence_tagged, :boolean
    add_column :patients, :workplace_tagged, :boolean
    add_column :patients, :permanent_residence_tagged, :boolean
  end
end
