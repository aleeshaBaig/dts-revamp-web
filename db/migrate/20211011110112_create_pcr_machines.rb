class CreatePcrMachines < ActiveRecord::Migration[6.0]
  def change
    create_table :pcr_machines do |t|
      t.integer :pcr_functional
      t.integer :pcr_non_functional
      t.integer :total_pcr_machines
      t.integer :hospital_id

      t.timestamps
    end
  end
end
