class AddOutcomeDatesToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :death_date, :date
    add_column :patients, :admission_date, :date
    add_column :patients, :lama_date, :date
  end
end
