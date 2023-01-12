class AddUcToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :uc, :string
  end
end
