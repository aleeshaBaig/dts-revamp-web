class CreateLegacyActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :legacy_activities do |t|
      t.integer :count
      t.integer :district_id
      t.integer :department_id
      t.date :act_date

      t.timestamps
    end
    add_index :legacy_activities, :district_id
    add_index :legacy_activities, :act_date
  end
end
