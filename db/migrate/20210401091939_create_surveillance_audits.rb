class CreateSurveillanceAudits < ActiveRecord::Migration[6.0]
  def up
    create_table :surveillance_audits do |t|
			t.integer  "mobile_user_id"
			t.string   "app_version"
			t.string   "location"
			t.float    "lat"
			t.float    "lng"
			t.integer  "no_of_containers_checked"
			t.text     "remarks"
			t.boolean  "visited_before"
			t.integer  "simple_activity_id"
			t.boolean  "rooftop_checked"
			t.boolean  "material_provided"
			t.boolean  "is_indoor"
			t.integer  "larvae_found_earlier"
			t.boolean  "larvae_found"
			t.integer  "time_taken"
			t.string   "picture_url"
      t.timestamps
    end
  end
  def down
  	drop_table :surveillance_audits
  end
end
