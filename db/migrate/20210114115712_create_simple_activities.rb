class CreateSimpleActivities < ActiveRecord::Migration[6.0]
  def up
    create_table :simple_activities do |t|
      t.integer :tag_category_id
      t.string :tag_category_name
      ## other fields
      t.boolean :larva_found
      t.integer :larva_type
      t.integer :io_action
      t.boolean :removal_water_stagnant
      t.boolean :removal_garbage
      t.boolean :removal_rof_top_cleaned
      t.boolean :old_record_sorted
      t.boolean :sops_follow

      t.text :comment
      t.string :tag_name
      t.integer :tag_id
      t.integer :app_version
      t.string :latitude
      t.string :longitude
      t.datetime :activity_time
      t.integer :os_version_number
      t.string :os_version_name
      t.integer :user_id
      t.integer :hotspot_id
      t.integer :tehsil_id
      t.string :tehsil_name
      t.string :uc_name
      t.integer :uc_id
      t.string :before_picture
      t.string :after_picture
      t.timestamps
    end
    add_index :simple_activities, :tag_category_id
    add_index :simple_activities, :tag_id
    add_index :simple_activities, :user_id
    add_index :simple_activities, :hotspot_id
  end
  def down
    drop_table :simple_activities
  end
end
