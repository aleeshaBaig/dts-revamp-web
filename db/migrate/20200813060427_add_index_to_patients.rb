class AddIndexToPatients < ActiveRecord::Migration[6.0]
  def change
  	add_index :patients, :cnic
  end
end