class AddColumnCommentsToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :comments, :text
  end
end
