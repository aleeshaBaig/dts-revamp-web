class CreatePatientAuditeds < ActiveRecord::Migration[6.0]
  def up
    create_table :patient_auditeds do |t|
	    t.integer  "mobile_user_id"
	    t.string   "app_version"
	    t.string   "location"
	    t.string   "lat"
	    t.string   "lng"
	    t.boolean  "conduction_place"
	    t.boolean  "sop_followed"
	    t.boolean  "response_conducted_at_place"
	    t.string   "comments"
	    t.text     "picture_url"
	    t.integer  "patient_activity_id"
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
	    t.boolean  "larvae_found"
      t.timestamps
    end
  end
  def down
  	drop_table :patient_auditeds
  end
end
