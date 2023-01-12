class CreateSurveillanceActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :surveillance_activities do |t|

      ## Basic information
      t.string :name
      t.string :shop_or_house
      t.text :address 
      t.integer :activity_type ## indoor / outdoor
      t.integer :surveillance_tag_id
      t.string :surveillance_tag_name
      
      ## District/Tehsil/Uc
      t.integer :district_id
      t.integer :tehsil_id
      t.integer :uc_id
      t.integer :province_id

      t.string :district_name
      t.string :tehsil_name
      t.string :uc_name

      ## Locations
      t.float :lat
      t.float :lng
      t.string :location

      ## Tags
      t.integer :tag_category_id
      t.string :tag_category_name
      t.integer :tag_id
      t.string :tag_name
      
      ## Containers value
      t.integer :checked_val
      t.integer :positive_val
      t.integer :total_checked
      t.integer :total_positive
      
      ## Mobile Version
      t.integer :mobile_user_id
      t.integer :os_version_number
      t.string :os_version_name
      t.string :app_version
      
      ## Datetime
      t.datetime :activity_time
      t.timestamps
    end

    ## Indexing
    add_index :surveillance_activities, :district_id
    add_index :surveillance_activities, :tehsil_id
    add_index :surveillance_activities, :uc_id
    add_index :surveillance_activities, :mobile_user_id
    add_index :surveillance_activities, :activity_type
    add_index :surveillance_activities, :surveillance_tag_id
  end
end
