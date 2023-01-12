class AddColumnTagCountToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :tag_count, :integer, default: 0
    add_column :patients, :is_tagged, :boolean, default: false


    add_index :patients, :is_tagged
  end
end
