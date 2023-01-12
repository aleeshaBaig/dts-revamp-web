class CreateMedicineStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :medicine_stocks do |t|
      t.string :medicine_name
      t.integer :stock_received
      t.integer :stock_dispensed
      t.integer :stock_in_hand
      t.integer :hospital_id

      t.timestamps
    end
  end
end
