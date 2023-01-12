class CreateMobileUserTehsils < ActiveRecord::Migration[6.0]
  def change
    create_table :mobile_user_tehsils do |t|
      t.integer :tehsil_id
      t.integer :mobile_user_id

      t.timestamps
    end
    add_index :mobile_user_tehsils, :tehsil_id
    add_index :mobile_user_tehsils, :mobile_user_id
  end
end
