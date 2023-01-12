class AddProvinceIdToCurrentAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :current_addresses, :province_id, :integer
  end
end
