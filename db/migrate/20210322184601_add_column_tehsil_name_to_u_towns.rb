class AddColumnTehsilNameToUTowns < ActiveRecord::Migration[6.0]
  def change
    add_column :u_towns, :tehsil_name, :string 
  end
end
