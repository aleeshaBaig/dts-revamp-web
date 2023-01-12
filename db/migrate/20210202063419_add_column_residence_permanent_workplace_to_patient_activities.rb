class AddColumnResidencePermanentWorkplaceToPatientActivities < ActiveRecord::Migration[6.0]
  def up
    add_column :patients, :residence_count, :integer, default: 0
    add_column :patients, :permanent_count, :integer, default: 0
    add_column :patients, :workplace_count, :integer,  default: 0

    add_column :patients, :is_residence_household, :boolean, default: false
    add_column :patients, :is_permanent_household, :boolean, default: false
    add_column :patients, :is_workplace_household, :boolean, default: false

    remove_column :patients, :tag_count
    remove_column :patients, :is_tagged
  end
  def down
    add_column :patients, :tag_count, :integer, default: 0
    add_column :patients, :is_tagged, :boolean

    remove_column :patients, :residence_count
    remove_column :patients, :permanent_count
    remove_column :patients, :workplace_count

    remove_column :patients, :is_residence_household
    remove_column :patients, :is_permanent_household
    remove_column :patients, :is_workplace_household

  end
end
