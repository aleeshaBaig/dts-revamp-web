class CreateUcs < ActiveRecord::Migration[6.0]
  def change
    create_table :ucs do |t|
      t.string :name
      t.integer :district_id
      t.integer :tehsil_id

      t.timestamps
    end
  end
end
