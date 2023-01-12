class AddActiveStatusToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :active_status, :boolean, :default => true
  end
end
