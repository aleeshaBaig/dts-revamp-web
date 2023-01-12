class AddAddressToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :address, :text
  end
end
