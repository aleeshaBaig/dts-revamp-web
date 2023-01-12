class AddIsReleasedToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :is_released, :boolean
  end
end
