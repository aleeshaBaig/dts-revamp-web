class AddDischargeDateToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :discharge_date, :date
  end
end
