class CreateUTowns < ActiveRecord::Migration[6.0]
  def up
    create_table :u_towns do |t|
      t.string :name
      t.integer :townable_id
      t.string :townable_type      
      t.integer :tehsil_id
      t.timestamps
    end
    add_index :u_towns, :townable_id
  end
  def down
    drop_table :u_towns
  end
end
