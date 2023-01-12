class AddProvinceIdToZeroPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :zero_patients, :province_id, :integer
  end
end
