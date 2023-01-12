class AddColumnTypeToHospitals < ActiveRecord::Migration[6.0]
  def change
    add_column :hospitals, :h_type, :integer, default: 0
    add_index :hospitals, :h_type
  end
end
