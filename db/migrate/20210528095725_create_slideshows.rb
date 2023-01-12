class CreateSlideshows < ActiveRecord::Migration[6.0]
  def change
    create_table :slideshows do |t|
      t.string :name
      t.integer :activity_type
      t.integer :user_id
      t.text :activity_ids, array:true, default: []
      t.integer :department_id

      t.timestamps
    end
    add_index :slideshows, :activity_type
    add_index :slideshows, :user_id
  end
end
