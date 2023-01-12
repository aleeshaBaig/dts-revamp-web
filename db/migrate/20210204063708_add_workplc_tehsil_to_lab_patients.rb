class AddWorkplcTehsilToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :workplc_tehsil, :string
  end
end
