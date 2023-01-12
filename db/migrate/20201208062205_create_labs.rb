class CreateLabs < ActiveRecord::Migration[6.0]
  def change
    create_table :labs do |t|
      t.string :lab_name
      t.integer :district_id
      t.string :lab_type

      t.timestamps
    end
  end
end
