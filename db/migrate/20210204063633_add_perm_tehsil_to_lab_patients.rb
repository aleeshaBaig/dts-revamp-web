class AddPermTehsilToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :perm_tehsil, :string
  end
end
