class AddProvinceIdToDivisions < ActiveRecord::Migration[6.0]
  def change
    add_column :divisions, :province_id, :integer
  end
end
