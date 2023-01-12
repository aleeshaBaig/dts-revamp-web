class AddFacilityToHospital < ActiveRecord::Migration[6.0]
  def change
    add_column :hospitals, :facility, :string
  end
end
