class AddDivisionIdToDistricts < ActiveRecord::Migration[6.0]
  def change
    add_column :districts, :division_id, :integer
  end
end
