class AddColumnCommentsToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :comments, :text
  end
end
