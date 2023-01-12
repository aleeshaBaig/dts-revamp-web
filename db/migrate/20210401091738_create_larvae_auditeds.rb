class CreateLarvaeAuditeds < ActiveRecord::Migration[6.0]
  def up
    create_table :larvae_auditeds do |t|
			t.integer  "mobile_user_id"
			t.string   "app_version"
			t.string   "location"
			t.string   "lat"
			t.string   "lng"
			t.boolean  "larvae_found"
			t.boolean  "larvae_found_before"
			t.boolean  "larviciding"
			t.string   "remarks"
			t.text     "comments"
			t.string   "larviciding_type"
			t.text     "picture_url"
			t.integer  "simple_activity_id"
			t.integer  "visited_before"
			t.string   "visit_adjacent_house"
			t.string   "chemical_option"
			t.integer  "larvaciding_conducted"
			t.string   "mechanical_option"
			t.integer  "biological_selected"
			t.string   "larva_found_from"
			t.integer  "chemical_selected"
			t.string   "awareenss_session"
			t.integer  "mechanical_selected"
			t.string   "last_visited"
			t.string   "supervisor_visited"
      t.timestamps
    end
  end
  def down
  	drop_table :larvae_auditeds
  end
  
end
