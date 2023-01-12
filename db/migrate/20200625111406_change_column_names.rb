class ChangeColumnNames < ActiveRecord::Migration[6.0]
  def change
  	rename_column :districts, :name, :district_name
  	rename_column :tehsils, :name, :tehsil_name
  	rename_column :ucs, :name, :uc_name
  	rename_column :hospitals, :name, :hospital_name
  end
end
