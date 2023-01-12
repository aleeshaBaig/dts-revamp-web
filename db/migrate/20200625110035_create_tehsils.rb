class CreateTehsils < ActiveRecord::Migration[6.0]
  def change
    create_table :tehsils do |t|
      t.string :name
      t.integer :district_id

      t.timestamps
    end
  end
end
