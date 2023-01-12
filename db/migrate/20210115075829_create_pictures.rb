class CreatePictures < ActiveRecord::Migration[6.0]
  def up
    create_table :pictures do |t|
      t.string :before_picture
      t.string :after_picture
      t.integer :pictureable_id
      t.string :pictureable_type

      t.timestamps
    end
    add_index :pictures, :pictureable_id
  end
  def down
    drop_table :pictures
  end
end
