class CreateContainerTags < ActiveRecord::Migration[6.0]
  def change
    create_table :container_tags do |t|
      t.integer :checked_val
      t.integer :positive_val

      t.integer :surveillance_tag_id
      t.string :surveillance_tag_name
      
      ## District/Tehsil/Uc
      t.integer :uc_id
      t.string :uc_name
      t.integer :tehsil_id
      t.string :tehsil_name
      t.integer :district_id
      t.string :district_name
      t.integer :province_id

      t.integer :surveillance_activity_id
      t.integer :mobile_user_id
      t.integer :activity_type #indoor,outdoor
      t.timestamps
    end

    ## Indexing
    add_index :container_tags, :surveillance_activity_id
    add_index :container_tags, :district_id
    add_index :container_tags, :tehsil_id
    add_index :container_tags, :uc_id
    
    add_index :container_tags, :mobile_user_id
    add_index :container_tags, :surveillance_tag_id
    add_index :container_tags, :activity_type

  end
end
