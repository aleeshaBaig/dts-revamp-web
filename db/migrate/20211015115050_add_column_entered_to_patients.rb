class AddColumnEnteredToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :entered_by, :integer, default: 0
  end
end
