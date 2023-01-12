class AddColumnProvinceIdToUcs < ActiveRecord::Migration[6.0]
  def change
    add_column :ucs, :province_id, :integer
  end
end
