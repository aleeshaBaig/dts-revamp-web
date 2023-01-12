class AddColumnPSearchTypeToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :p_search_type, :integer, default: 0
  end
end
