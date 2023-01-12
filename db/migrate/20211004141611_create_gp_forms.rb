class CreateGpForms < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_forms do |t|
      t.integer :gp_dengue_user_id
      t.integer :provisional_diagnosis
      t.boolean :is_deleted, default: false
      t.string :before_picture
      t.string :app_version
      t.datetime :activity_time
      t.timestamps
    end
    add_index :gp_forms, :gp_dengue_user_id
    add_index :gp_forms, :provisional_diagnosis
  end
end
