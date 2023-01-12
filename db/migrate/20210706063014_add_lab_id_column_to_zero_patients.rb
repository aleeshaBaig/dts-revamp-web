class AddLabIdColumnToZeroPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :zero_patients, :lab_id, :integer
  end
end
