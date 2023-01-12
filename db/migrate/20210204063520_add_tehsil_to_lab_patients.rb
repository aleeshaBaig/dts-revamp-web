class AddTehsilToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :tehsil, :string
  end
end
