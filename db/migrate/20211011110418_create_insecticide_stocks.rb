class CreateInsecticideStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :insecticide_stocks do |t|
      t.string :insecticide_name
      t.integer :stock_received
      t.integer :stock_dispensed
      t.integer :stock_in_hand
      t.integer :district_id

      t.timestamps
    end
  end
end
