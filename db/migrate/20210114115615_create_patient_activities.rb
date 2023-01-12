class CreatePatientActivities < ActiveRecord::Migration[6.0]
  def up
    create_table :patient_activities do |t|
      t.integer :tag_category_id
      t.string :tag_category_name
      ## other fields
      t.boolean :awareness
      t.boolean :removal_bleeding_spot
      t.boolean :elimination_bleeding_spot
      t.boolean :patient_spray
      
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
      t.integer :patient_id
      t.string :uc_name
      t.integer :uc_id
      t.string :tehsil_name
      t.integer :tehsil_id
      t.string :before_picture
      t.string :after_picture
      t.timestamps
    end
    add_index :patient_activities, :tag_category_id
    add_index :patient_activities, :user_id
    add_index :patient_activities, :patient_id
  end
  def down
    drop_table :patient_activities
  end
end
