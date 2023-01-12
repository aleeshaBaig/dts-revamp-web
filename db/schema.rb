# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_01_02_095537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archived21_simple_activities", id: :bigint, default: -> { "nextval('simple_activities_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "tag_category_id"
    t.string "tag_category_name"
    t.boolean "larva_found"
    t.integer "larva_type"
    t.integer "io_action"
    t.boolean "removal_water_stagnant"
    t.boolean "removal_garbage"
    t.boolean "removal_rof_top_cleaned"
    t.boolean "old_record_sorted"
    t.boolean "sops_follow"
    t.text "comment"
    t.string "tag_name"
    t.integer "tag_id"
    t.integer "app_version"
    t.string "latitude"
    t.string "longitude"
    t.datetime "activity_time"
    t.integer "os_version_number"
    t.string "os_version_name"
    t.integer "user_id"
    t.integer "hotspot_id"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.string "uc_name"
    t.integer "uc_id"
    t.string "before_picture"
    t.string "after_picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "department_id"
    t.string "department_name"
    t.integer "district_id"
    t.string "district_name"
    t.text "description"
    t.boolean "is_bogus"
    t.integer "province_id"
    t.index ["hotspot_id"], name: "archived21_simple_activities_hotspot_id_idx"
    t.index ["tag_category_id"], name: "archived21_simple_activities_tag_category_id_idx"
    t.index ["tag_id"], name: "archived21_simple_activities_tag_id_idx"
    t.index ["user_id"], name: "archived21_simple_activities_user_id_idx"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "beds", force: :cascade do |t|
    t.bigint "total_ward_beds", default: 0
    t.bigint "occupied_ward_beds", default: 0
    t.bigint "total_hdu_beds", default: 0
    t.bigint "occupied_hdu_beds", default: 0
    t.integer "hospital_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ward_beds_ramp_up", default: 0
    t.integer "hdu_beds_ramp_up", default: 0
    t.datetime "last_updated_at"
    t.index ["hospital_id"], name: "index_beds_on_hospital_id"
  end

  create_table "container_tags", force: :cascade do |t|
    t.integer "checked_val"
    t.integer "positive_val"
    t.integer "surveillance_tag_id"
    t.string "surveillance_tag_name"
    t.integer "uc_id"
    t.string "uc_name"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.integer "district_id"
    t.string "district_name"
    t.integer "province_id"
    t.integer "surveillance_activity_id"
    t.integer "mobile_user_id"
    t.integer "activity_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_type"], name: "index_container_tags_on_activity_type"
    t.index ["district_id"], name: "index_container_tags_on_district_id"
    t.index ["mobile_user_id"], name: "index_container_tags_on_mobile_user_id"
    t.index ["surveillance_activity_id"], name: "index_container_tags_on_surveillance_activity_id"
    t.index ["surveillance_tag_id"], name: "index_container_tags_on_surveillance_tag_id"
    t.index ["tehsil_id"], name: "index_container_tags_on_tehsil_id"
    t.index ["uc_id"], name: "index_container_tags_on_uc_id"
  end

  create_table "current_addresses", force: :cascade do |t|
    t.integer "district_id"
    t.string "district_name"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.integer "uc_id"
    t.string "uc_name"
    t.integer "gp_dengue_patient_id"
    t.text "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "province_id"
    t.index ["district_id"], name: "index_current_addresses_on_district_id"
    t.index ["tehsil_id"], name: "index_current_addresses_on_tehsil_id"
    t.index ["uc_id"], name: "index_current_addresses_on_uc_id"
  end

  create_table "dengue_situations", force: :cascade do |t|
    t.integer "confirmed_patient"
    t.integer "patient_reported_by_lab"
    t.integer "patient_reported_by_hospital"
    t.integer "death"
    t.integer "admissions"
    t.integer "case_reponse"
    t.integer "indoor_positive_larvae"
    t.integer "outdoor_positive_larvae"
    t.integer "hotspots_coverage"
    t.integer "dormant_users"
    t.integer "firs"
    t.integer "notices_served"
    t.integer "premises_sealed"
    t.integer "arrests"
    t.integer "fines_imposed"
    t.bigint "dvrs_total"
    t.integer "dvrs_resolved"
    t.integer "dvrs_pending"
    t.date "entery_date", default: "2022-09-28"
    t.integer "user_id"
    t.integer "district_id"
    t.string "district_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "version_code"
    t.index ["entery_date"], name: "index_dengue_situations_on_entery_date", using: :brin
  end

  create_table "department_tags", force: :cascade do |t|
    t.integer "department_id"
    t.integer "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "department_name"
    t.string "department_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string "district_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "province_id"
    t.integer "division_id"
    t.string "division_name"
  end

  create_table "divisions", force: :cascade do |t|
    t.string "division_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "province_id"
  end

  create_table "gp_dengue_patients", force: :cascade do |t|
    t.integer "gp_dengue_user_id"
    t.string "patient_name"
    t.string "fh_name"
    t.integer "gender"
    t.integer "age"
    t.integer "age_month"
    t.string "dob"
    t.string "contact_no"
    t.integer "provisional_diagnosis"
    t.integer "lab_id"
    t.integer "hospital_id"
    t.integer "reffer_type"
    t.string "app_version"
    t.datetime "activity_time"
    t.float "lat"
    t.float "lng"
    t.string "before_picture"
    t.string "after_picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "hospital_name"
    t.string "cnic"
    t.index ["contact_no"], name: "index_gp_dengue_patients_on_contact_no"
    t.index ["provisional_diagnosis"], name: "index_gp_dengue_patients_on_provisional_diagnosis"
    t.index ["reffer_type"], name: "index_gp_dengue_patients_on_reffer_type"
  end

  create_table "gp_dengue_users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "clinic_name"
    t.string "contact_no"
    t.string "pmdc_number"
    t.integer "role"
    t.integer "district_id"
    t.string "district_name"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.integer "uc_id"
    t.string "uc_name"
    t.integer "hospital_id"
    t.string "hospital_name"
    t.text "address"
    t.string "city_name"
    t.string "lat"
    t.string "lng"
    t.boolean "status", default: true
    t.boolean "is_logged_in", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_no"], name: "index_gp_dengue_users_on_contact_no", unique: true
    t.index ["district_id"], name: "index_gp_dengue_users_on_district_id"
    t.index ["email"], name: "index_gp_dengue_users_on_email", unique: true
    t.index ["hospital_id"], name: "index_gp_dengue_users_on_hospital_id"
    t.index ["pmdc_number"], name: "index_gp_dengue_users_on_pmdc_number", unique: true
    t.index ["role"], name: "index_gp_dengue_users_on_role"
    t.index ["tehsil_id"], name: "index_gp_dengue_users_on_tehsil_id"
    t.index ["uc_id"], name: "index_gp_dengue_users_on_uc_id"
  end

  create_table "gp_forms", force: :cascade do |t|
    t.integer "gp_dengue_user_id"
    t.integer "provisional_diagnosis"
    t.boolean "is_deleted", default: false
    t.string "before_picture"
    t.string "app_version"
    t.datetime "activity_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gp_dengue_user_id"], name: "index_gp_forms_on_gp_dengue_user_id"
    t.index ["provisional_diagnosis"], name: "index_gp_forms_on_provisional_diagnosis"
  end

  create_table "gp_lab_diagnostices", force: :cascade do |t|
    t.integer "ns1"
    t.date "ns1_date"
    t.integer "pcr"
    t.date "pcr_date"
    t.date "sero_type"
    t.integer "igm"
    t.date "igm_date"
    t.integer "igg"
    t.date "igg_date"
    t.integer "dengue_fever_type"
    t.integer "gp_dengue_patient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gp_dengue_patient_id"], name: "index_gp_lab_diagnostices_on_gp_dengue_patient_id"
  end

  create_table "gp_lab_results", force: :cascade do |t|
    t.integer "hct_first_reading"
    t.date "hct_reading_date"
    t.integer "wbc_first_reading"
    t.date "wbc_reading_date"
    t.integer "platelet_first_reading"
    t.date "platelet_reading_date"
    t.integer "warning_sign"
    t.integer "gp_dengue_patient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gp_dengue_patient_id"], name: "index_gp_lab_results_on_gp_dengue_patient_id"
  end

  create_table "gp_patients", force: :cascade do |t|
    t.integer "gp_user_id"
    t.datetime "reporting_date"
    t.string "patient_name"
    t.string "fh_name"
    t.string "dob"
    t.integer "age"
    t.float "age_month"
    t.string "gender"
    t.string "cnic"
    t.string "phone_number"
    t.string "district"
    t.string "town_tehsil"
    t.string "uc_name"
    t.string "occupation"
    t.string "lat"
    t.string "long"
    t.date "onset_date_fever"
    t.boolean "prev_dengue_fever"
    t.boolean "fever"
    t.boolean "warning_signs"
    t.string "provisional_diagnosis"
    t.string "igg_performed"
    t.string "igm_performed"
    t.string "antigen_performed"
    t.integer "wbc_first_reading"
    t.date "wbc_first_date"
    t.string "dengue_type"
    t.string "diagnosis"
    t.string "patient_status"
    t.text "comments"
    t.string "patient_type"
    t.string "patient_condition"
    t.string "street_no_name"
    t.string "house_no"
    t.string "viral_detection_performed"
    t.string "hospital_name"
    t.string "locality"
    t.boolean "is_app_user"
    t.string "residence_address"
    t.string "workplace_address"
    t.string "reffer_to"
    t.string "symptoms"
    t.string "platelets_reading"
    t.date "platelets_date"
    t.string "vitals"
    t.boolean "headache"
    t.boolean "retro_orbital_pain"
    t.boolean "myalgia"
    t.boolean "arthralgia_backache"
    t.boolean "irritability_in_infants"
    t.boolean "rash"
    t.boolean "bleeding_manisfestations"
    t.boolean "severe_abdominal_pain"
    t.boolean "decreased_urinary_output"
    t.integer "temprature"
    t.integer "hr"
    t.integer "bp_s"
    t.integer "bp_d"
    t.string "refered_to_confirmed"
    t.string "probable_patient_status"
    t.string "probable_comments"
    t.string "present_address"
    t.boolean "has_fever"
    t.string "pp"
    t.boolean "wbc1lessthan4000"
    t.boolean "platelets_less_than_lakh"
    t.boolean "no_clinical_improvement"
    t.boolean "persistent_vomiting"
    t.boolean "lethargy_restlessness"
    t.boolean "giddiness"
    t.boolean "clammy_extremities"
    t.boolean "bleeding_epistaxis"
    t.boolean "hematemesis"
    t.boolean "hct"
    t.boolean "pulse_pressure"
    t.boolean "no_urine_output"
    t.date "ns1_reading_date"
    t.string "detection_by_pcr"
    t.date "pcr_detection_date"
    t.date "igm_reading_date"
    t.date "igg_reading_date"
    t.boolean "df"
    t.boolean "dhf"
    t.boolean "dss"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "district_id"
    t.integer "tehsil_id"
    t.integer "uc_id"
    t.integer "province_id"
  end

  create_table "gp_symptoms", force: :cascade do |t|
    t.boolean "fever"
    t.date "fever_date"
    t.integer "associate_symptom"
    t.integer "gp_dengue_patient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gp_dengue_patient_id"], name: "index_gp_symptoms_on_gp_dengue_patient_id"
  end

  create_table "gp_users", force: :cascade do |t|
    t.string "name"
    t.string "clinic"
    t.string "contact_no"
    t.string "district"
    t.text "address"
    t.string "city_name"
    t.string "division"
    t.string "doctor_name"
    t.string "email"
    t.string "facility_type"
    t.string "hospital"
    t.boolean "is_mobile_signup"
    t.string "lat"
    t.string "lng"
    t.string "password"
    t.string "pmdc_number"
    t.string "tehsil"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["district"], name: "index_gp_users_on_district"
    t.index ["doctor_name"], name: "index_gp_users_on_doctor_name"
    t.index ["email"], name: "index_gp_users_on_email"
    t.index ["facility_type"], name: "index_gp_users_on_facility_type"
    t.index ["is_mobile_signup"], name: "index_gp_users_on_is_mobile_signup"
    t.index ["name"], name: "index_gp_users_on_name"
    t.index ["password"], name: "index_gp_users_on_password"
    t.index ["pmdc_number"], name: "index_gp_users_on_pmdc_number"
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "hospital_name"
    t.integer "district_id"
    t.string "facility_type"
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "facility"
    t.integer "h_type", default: 0
    t.integer "province_id"
    t.index ["h_type"], name: "index_hospitals_on_h_type"
  end

  create_table "hotspots", force: :cascade do |t|
    t.string "tehsil"
    t.string "uc"
    t.string "address"
    t.string "tag"
    t.string "description"
    t.string "hotspot_name"
    t.string "lat"
    t.string "long"
    t.integer "district_id"
    t.string "district"
    t.boolean "is_active"
    t.integer "tehsil_id"
    t.integer "uc_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tag_id"
    t.string "contact_no"
    t.datetime "last_visited"
    t.integer "is_tagged", default: 0
    t.integer "hotspot_updated_by"
  end

  create_table "insecticide_stocks", force: :cascade do |t|
    t.string "insecticide_name"
    t.integer "stock_received"
    t.integer "stock_dispensed"
    t.integer "stock_in_hand"
    t.integer "district_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "lab_patients", force: :cascade do |t|
    t.string "lab_name"
    t.string "p_name"
    t.string "fh_name"
    t.string "gender"
    t.string "occupation"
    t.string "contact_no"
    t.string "other_contact_no"
    t.string "cnic"
    t.string "cnic_type"
    t.string "house_no"
    t.string "street_no"
    t.string "locality"
    t.integer "district_id"
    t.integer "tehsil_id"
    t.integer "uc_id"
    t.integer "hct_first_reading"
    t.date "hct_first_reading_date"
    t.float "wbc_first_reading"
    t.date "wbc_first_reading_date"
    t.integer "platelet_first_reading"
    t.date "platelet_first_reading_date"
    t.integer "hct_second_reading"
    t.date "hct_second_reading_date"
    t.float "wbc_second_reading"
    t.date "wbc_second_reading_date"
    t.string "platelet_second_reading"
    t.date "platelet_second_reading_date"
    t.string "hct_third_reading"
    t.date "hct_third_reading_date"
    t.float "wbc_third_reading"
    t.date "wbc_third_reading_date"
    t.string "platelet_third_reading"
    t.date "platelet_third_reading_date"
    t.string "ns_1"
    t.string "igg"
    t.string "igm"
    t.string "pcr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "perm_house_no"
    t.string "perm_street_no"
    t.string "perm_locality"
    t.integer "perm_district_id"
    t.integer "perm_tehsil_id"
    t.integer "perm_uc_id"
    t.string "workplc_house_no"
    t.string "workplc_street_no"
    t.string "workplc_locality"
    t.integer "workplc_district_id"
    t.integer "workplc_tehsil_id"
    t.integer "workplc_uc_id"
    t.text "address"
    t.text "perm_address"
    t.text "workplc_address"
    t.string "district"
    t.string "tehsil"
    t.string "uc"
    t.string "perm_district"
    t.string "perm_tehsil"
    t.string "perm_uc"
    t.string "workplc_district"
    t.string "workplc_tehsil"
    t.string "workplc_uc"
    t.integer "lab_id"
    t.integer "age"
    t.integer "month"
    t.integer "provisional_diagnosis"
    t.boolean "is_dpc", default: false
    t.integer "transfer_type", default: 0
    t.date "reporting_date"
    t.datetime "confirmation_date"
    t.text "comments"
    t.index ["confirmation_date"], name: "index_lab_patients_on_confirmation_date"
    t.index ["is_dpc"], name: "index_lab_patients_on_is_dpc"
    t.index ["lab_id"], name: "index_lab_patients_on_lab_id"
    t.index ["transfer_type"], name: "index_lab_patients_on_transfer_type"
  end

  create_table "lab_results", force: :cascade do |t|
    t.integer "hct_first_reading"
    t.float "wbc_first_reading"
    t.integer "platelet_first_reading"
    t.integer "hct_second_reading"
    t.float "wbc_second_reading"
    t.integer "platelet_second_reading"
    t.boolean "warning_signs"
    t.string "ns1"
    t.string "pcr"
    t.string "igm"
    t.string "igg"
    t.string "diagnosis"
    t.string "dengue_virus_type"
    t.integer "patient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "hct_first_reading_date"
    t.date "hct_second_reading_date"
    t.date "hct_third_reading_date"
    t.integer "hct_third_reading"
    t.date "wbc_first_reading_date"
    t.date "wbc_second_reading_date"
    t.date "wbc_third_reading_date"
    t.float "wbc_third_reading"
    t.date "platelet_first_reading_date"
    t.date "platelet_second_reading_date"
    t.date "platelet_third_reading_date"
    t.integer "platelet_third_reading"
    t.integer "lab_patient_id"
    t.text "advised_test"
    t.datetime "report_ordering_date"
    t.datetime "report_receiving_date"
    t.datetime "cbc_report_order_date_first"
    t.datetime "cbc_report_order_date_second"
    t.datetime "cbc_report_order_date_third"
    t.datetime "cbc_report_receiving_date_first"
    t.datetime "cbc_report_receiving_date_second"
    t.datetime "cbc_report_receiving_date_third"
    t.integer "cbc_turnaround_first"
    t.integer "cbc_turnaround_second"
    t.integer "cbc_turnaround_third"
    t.integer "lab_turnaround_time"
  end

  create_table "labs", force: :cascade do |t|
    t.string "lab_name"
    t.integer "district_id"
    t.string "lab_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "larvae_auditeds", force: :cascade do |t|
    t.integer "mobile_user_id"
    t.string "app_version"
    t.string "location"
    t.string "lat"
    t.string "lng"
    t.boolean "larvae_found"
    t.boolean "larvae_found_before"
    t.boolean "larviciding"
    t.string "remarks"
    t.text "comments"
    t.string "larviciding_type"
    t.text "picture_url"
    t.integer "simple_activity_id"
    t.integer "visited_before"
    t.string "visit_adjacent_house"
    t.string "chemical_option"
    t.integer "larvaciding_conducted"
    t.string "mechanical_option"
    t.integer "biological_selected"
    t.string "larva_found_from"
    t.integer "chemical_selected"
    t.string "awareenss_session"
    t.integer "mechanical_selected"
    t.string "last_visited"
    t.string "supervisor_visited"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "legacy_activities", force: :cascade do |t|
    t.integer "count"
    t.integer "district_id"
    t.integer "department_id"
    t.date "act_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["act_date"], name: "index_legacy_activities_on_act_date"
    t.index ["district_id"], name: "index_legacy_activities_on_district_id"
  end

  create_table "medicine_stocks", force: :cascade do |t|
    t.string "medicine_name"
    t.integer "stock_received"
    t.integer "stock_dispensed"
    t.integer "stock_in_hand"
    t.integer "hospital_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "mobile_user_tehsils", force: :cascade do |t|
    t.integer "tehsil_id"
    t.integer "mobile_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mobile_user_id"], name: "index_mobile_user_tehsils_on_mobile_user_id"
    t.index ["tehsil_id"], name: "index_mobile_user_tehsils_on_tehsil_id"
  end

  create_table "mobile_users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_logged_in"
    t.string "tehsil"
    t.integer "tehsil_id"
    t.string "district"
    t.integer "district_id"
    t.string "uc"
    t.integer "uc_id"
    t.integer "department_id"
    t.boolean "status"
    t.boolean "is_forgot", default: false
    t.boolean "is_surveillance", default: false
    t.integer "division_id"
  end

  create_table "motor_alert_locks", force: :cascade do |t|
    t.bigint "alert_id", null: false
    t.string "lock_timestamp", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alert_id", "lock_timestamp"], name: "index_motor_alert_locks_on_alert_id_and_lock_timestamp", unique: true
    t.index ["alert_id"], name: "index_motor_alert_locks_on_alert_id"
  end

  create_table "motor_alerts", force: :cascade do |t|
    t.bigint "query_id", null: false
    t.string "name", null: false
    t.text "description"
    t.text "to_emails", null: false
    t.boolean "is_enabled", default: true, null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "motor_alerts_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["query_id"], name: "index_motor_alerts_on_query_id"
    t.index ["updated_at"], name: "index_motor_alerts_on_updated_at"
  end

  create_table "motor_audits", force: :cascade do |t|
    t.bigint "auditable_id"
    t.string "auditable_type"
    t.bigint "associated_id"
    t.string "associated_type"
    t.bigint "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.bigint "version", default: 0
    t.text "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "motor_auditable_associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "motor_auditable_index"
    t.index ["created_at"], name: "index_motor_audits_on_created_at"
    t.index ["request_uuid"], name: "index_motor_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "motor_auditable_user_index"
  end

  create_table "motor_configs", force: :cascade do |t|
    t.string "key", null: false
    t.text "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_motor_configs_on_key", unique: true
    t.index ["updated_at"], name: "index_motor_configs_on_updated_at"
  end

  create_table "motor_dashboards", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "motor_dashboards_title_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_dashboards_on_updated_at"
  end

  create_table "motor_forms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "api_path", null: false
    t.string "http_method", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "motor_forms_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_forms_on_updated_at"
  end

  create_table "motor_queries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "sql_body", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "motor_queries_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_queries_on_updated_at"
  end

  create_table "motor_resources", force: :cascade do |t|
    t.string "name", null: false
    t.text "preferences", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_motor_resources_on_name", unique: true
    t.index ["updated_at"], name: "index_motor_resources_on_updated_at"
  end

  create_table "motor_taggable_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.index ["tag_id"], name: "index_motor_taggable_tags_on_tag_id"
    t.index ["taggable_id", "taggable_type", "tag_id"], name: "motor_polymorphic_association_tag_index", unique: true
  end

  create_table "motor_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "motor_tags_name_unique_index", unique: true
  end

  create_table "old_simple_activities", id: :bigint, default: -> { "nextval('simple_activities_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "tag_category_id"
    t.string "tag_category_name"
    t.boolean "larva_found"
    t.integer "larva_type"
    t.integer "io_action"
    t.boolean "removal_water_stagnant"
    t.boolean "removal_garbage"
    t.boolean "removal_rof_top_cleaned"
    t.boolean "old_record_sorted"
    t.boolean "sops_follow"
    t.text "comment"
    t.string "tag_name"
    t.integer "tag_id"
    t.integer "app_version"
    t.string "latitude"
    t.string "longitude"
    t.datetime "activity_time"
    t.integer "os_version_number"
    t.string "os_version_name"
    t.integer "user_id"
    t.integer "hotspot_id"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.string "uc_name"
    t.integer "uc_id"
    t.string "before_picture"
    t.string "after_picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "department_id"
    t.string "department_name"
    t.integer "district_id"
    t.string "district_name"
    t.text "description"
    t.boolean "is_bogus"
    t.integer "province_id"
    t.index ["hotspot_id"], name: "index_simple_activities_on_hotspot_id"
    t.index ["tag_category_id"], name: "index_simple_activities_on_tag_category_id"
    t.index ["tag_id"], name: "index_simple_activities_on_tag_id"
    t.index ["user_id"], name: "index_simple_activities_on_user_id"
  end

  create_table "patient_activities", force: :cascade do |t|
    t.integer "tag_category_id"
    t.string "tag_category_name"
    t.boolean "awareness"
    t.boolean "removal_bleeding_spot"
    t.boolean "elimination_bleeding_spot"
    t.boolean "patient_spray"
    t.text "comment"
    t.string "tag_name"
    t.integer "tag_id"
    t.integer "app_version"
    t.string "latitude"
    t.string "longitude"
    t.datetime "activity_time"
    t.integer "os_version_number"
    t.string "os_version_name"
    t.integer "user_id"
    t.integer "patient_id"
    t.string "uc_name"
    t.integer "uc_id"
    t.string "tehsil_name"
    t.integer "tehsil_id"
    t.string "before_picture"
    t.string "after_picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "patient_place"
    t.integer "department_id"
    t.string "department_name"
    t.integer "district_id"
    t.string "district_name"
    t.integer "provisional_diagnosis"
    t.text "description"
    t.integer "province_id"
    t.datetime "pb_time"
    t.datetime "pa_time"
    t.integer "pdif_time", default: 0
    t.index ["patient_id"], name: "index_patient_activities_on_patient_id"
    t.index ["patient_place"], name: "index_patient_activities_on_patient_place"
    t.index ["provisional_diagnosis"], name: "index_patient_activities_on_provisional_diagnosis"
    t.index ["tag_category_id"], name: "index_patient_activities_on_tag_category_id"
    t.index ["user_id"], name: "index_patient_activities_on_user_id"
  end

  create_table "patient_auditeds", force: :cascade do |t|
    t.integer "mobile_user_id"
    t.string "app_version"
    t.string "location"
    t.string "lat"
    t.string "lng"
    t.boolean "conduction_place"
    t.boolean "sop_followed"
    t.boolean "response_conducted_at_place"
    t.string "comments"
    t.text "picture_url"
    t.integer "patient_activity_id"
    t.integer "visited_before"
    t.string "visit_adjacent_house"
    t.string "chemical_option"
    t.integer "larvaciding_conducted"
    t.string "mechanical_option"
    t.integer "biological_selected"
    t.string "larva_found_from"
    t.integer "chemical_selected"
    t.string "awareenss_session"
    t.integer "mechanical_selected"
    t.string "last_visited"
    t.string "supervisor_visited"
    t.boolean "larvae_found"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "patients", force: :cascade do |t|
    t.string "patient_name"
    t.string "fh_name"
    t.integer "age"
    t.integer "age_month"
    t.string "gender"
    t.string "cnic"
    t.string "cnic_relation"
    t.string "patient_contact"
    t.string "relation_contact"
    t.text "address"
    t.string "district"
    t.integer "district_id"
    t.string "tehsil"
    t.integer "tehsil_id"
    t.string "uc"
    t.integer "uc_id"
    t.text "permanent_address"
    t.string "permanent_district"
    t.integer "permanent_district_id"
    t.string "permanent_tehsil"
    t.integer "permanent_tehsil_id"
    t.string "permanent_uc"
    t.integer "permanent_uc_id"
    t.text "workplace_address"
    t.string "workplace_district"
    t.integer "workplace_district_id"
    t.string "workplace_tehsil"
    t.integer "workplace_tehsil_id"
    t.string "workplace_uc"
    t.integer "workplace_uc_id"
    t.date "date_of_onset"
    t.date "fever_last_till"
    t.boolean "fever"
    t.boolean "previous_dengue_fever"
    t.boolean "associated_symptom"
    t.integer "provisional_diagnosis"
    t.string "other_diagnosed_fever"
    t.integer "patient_status"
    t.integer "patient_outcome"
    t.integer "patient_condition"
    t.string "hospital"
    t.integer "hospital_id"
    t.integer "user_id"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "reporting_date"
    t.boolean "active_status", default: true
    t.integer "referred_to_id"
    t.string "referred_to"
    t.integer "referred_from_id"
    t.string "referred_reason"
    t.boolean "currently_referred"
    t.boolean "is_released"
    t.boolean "residence_tagged"
    t.boolean "workplace_tagged"
    t.boolean "permanent_residence_tagged"
    t.integer "residence_count", default: 0
    t.integer "permanent_count", default: 0
    t.integer "workplace_count", default: 0
    t.boolean "is_residence_household", default: false
    t.boolean "is_permanent_household", default: false
    t.boolean "is_workplace_household", default: false
    t.boolean "is_dpc", default: false
    t.integer "transfer_type", default: 0
    t.integer "lab_patient_id"
    t.datetime "deleted_at"
    t.datetime "confirmation_date"
    t.text "comments"
    t.integer "lab_user_id"
    t.string "lab_user_name"
    t.integer "updated_id"
    t.date "death_date"
    t.date "admission_date"
    t.date "lama_date"
    t.date "discharge_date"
    t.integer "lab_id"
    t.string "lab_name"
    t.integer "entered_by", default: 0
    t.integer "province_id"
    t.integer "confirmation_id"
    t.integer "confirmation_role"
    t.integer "p_search_type", default: 0
    t.string "passport"
    t.index ["cnic"], name: "index_patients_on_cnic"
    t.index ["confirmation_date"], name: "index_patients_on_confirmation_date"
    t.index ["confirmation_id"], name: "index_patients_on_confirmation_id"
    t.index ["deleted_at"], name: "index_patients_on_deleted_at"
    t.index ["is_dpc"], name: "index_patients_on_is_dpc"
    t.index ["lab_patient_id"], name: "index_patients_on_lab_patient_id"
    t.index ["lab_user_id"], name: "index_patients_on_lab_user_id"
    t.index ["passport"], name: "index_patients_on_passport"
    t.index ["transfer_type"], name: "index_patients_on_transfer_type"
  end

  create_table "pcr_machines", force: :cascade do |t|
    t.integer "pcr_functional"
    t.integer "pcr_non_functional"
    t.integer "total_pcr_machines"
    t.integer "hospital_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "permanent_addresses", force: :cascade do |t|
    t.integer "district_id"
    t.string "district_name"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.integer "uc_id"
    t.string "uc_name"
    t.integer "gp_dengue_patient_id"
    t.text "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["district_id"], name: "index_permanent_addresses_on_district_id"
    t.index ["gp_dengue_patient_id"], name: "index_permanent_addresses_on_gp_dengue_patient_id"
    t.index ["tehsil_id"], name: "index_permanent_addresses_on_tehsil_id"
    t.index ["uc_id"], name: "index_permanent_addresses_on_uc_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "before_picture"
    t.string "after_picture"
    t.integer "pictureable_id"
    t.string "pictureable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pictureable_tag"
    t.index ["pictureable_id"], name: "index_pictures_on_pictureable_id"
  end

  create_table "ppe_stocks", force: :cascade do |t|
    t.string "ppe_name"
    t.integer "stock_received"
    t.integer "stock_dispensed"
    t.integer "stock_in_hand"
    t.integer "hospital_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.string "province_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "simple_activities", force: :cascade do |t|
    t.integer "tag_category_id"
    t.string "tag_category_name"
    t.boolean "larva_found"
    t.integer "larva_type"
    t.integer "io_action"
    t.boolean "removal_water_stagnant"
    t.boolean "removal_garbage"
    t.boolean "removal_rof_top_cleaned"
    t.boolean "old_record_sorted"
    t.boolean "sops_follow"
    t.text "comment"
    t.string "tag_name"
    t.integer "tag_id"
    t.integer "app_version"
    t.string "latitude"
    t.string "longitude"
    t.datetime "activity_time"
    t.integer "os_version_number"
    t.string "os_version_name"
    t.integer "user_id"
    t.integer "hotspot_id"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.string "uc_name"
    t.integer "uc_id"
    t.string "before_picture"
    t.string "after_picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "department_id"
    t.string "department_name"
    t.integer "district_id"
    t.string "district_name"
    t.text "description"
    t.boolean "is_bogus"
    t.integer "province_id"
    t.datetime "pb_time"
    t.datetime "pa_time"
    t.integer "pdif_time", default: 0
    t.index ["hotspot_id"], name: "archived22_simple_activities_hotspot_id_idx"
    t.index ["tag_category_id"], name: "archived22_simple_activities_tag_category_id_idx"
    t.index ["tag_id"], name: "archived22_simple_activities_tag_id_idx"
    t.index ["user_id"], name: "archived22_simple_activities_user_id_idx"
  end

  create_table "slideshows", force: :cascade do |t|
    t.string "name"
    t.integer "activity_type"
    t.integer "user_id"
    t.text "activity_ids", default: [], array: true
    t.integer "department_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_type"], name: "index_slideshows_on_activity_type"
    t.index ["user_id"], name: "index_slideshows_on_user_id"
  end

  create_table "surveillance_activities", force: :cascade do |t|
    t.string "name"
    t.string "shop_or_house"
    t.text "address"
    t.integer "activity_type"
    t.integer "district_id"
    t.integer "tehsil_id"
    t.integer "uc_id"
    t.integer "province_id"
    t.string "district_name"
    t.string "tehsil_name"
    t.string "uc_name"
    t.float "lat"
    t.float "lng"
    t.string "location"
    t.integer "tag_category_id"
    t.string "tag_category_name"
    t.integer "tag_id"
    t.string "tag_name"
    t.integer "mobile_user_id"
    t.integer "os_version_number"
    t.string "os_version_name"
    t.string "app_version"
    t.datetime "activity_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_type"], name: "index_surveillance_activities_on_activity_type"
    t.index ["district_id"], name: "index_surveillance_activities_on_district_id"
    t.index ["mobile_user_id"], name: "index_surveillance_activities_on_mobile_user_id"
    t.index ["tehsil_id"], name: "index_surveillance_activities_on_tehsil_id"
    t.index ["uc_id"], name: "index_surveillance_activities_on_uc_id"
  end

  create_table "surveillance_audits", force: :cascade do |t|
    t.integer "mobile_user_id"
    t.string "app_version"
    t.string "location"
    t.float "lat"
    t.float "lng"
    t.integer "no_of_containers_checked"
    t.text "remarks"
    t.boolean "visited_before"
    t.integer "simple_activity_id"
    t.boolean "rooftop_checked"
    t.boolean "material_provided"
    t.boolean "is_indoor"
    t.integer "larvae_found_earlier"
    t.boolean "larvae_found"
    t.integer "time_taken"
    t.string "picture_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "surveillance_tags", force: :cascade do |t|
    t.string "name"
    t.string "tag_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tag_categories", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "urdu"
    t.integer "m_category_id"
    t.string "category_name_en"
  end

  create_table "tag_options", force: :cascade do |t|
    t.string "option_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "m_option_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tag_category_id"
    t.string "tag_image_url"
    t.string "tag_options"
    t.string "urdu"
    t.integer "m_tag_id"
    t.integer "m_category_id"
    t.string "tag_name_en"
  end

  create_table "tehsils", force: :cascade do |t|
    t.string "tehsil_name"
    t.integer "district_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "test_logs", force: :cascade do |t|
    t.integer "hct_first_reading"
    t.date "hct_first_reading_date"
    t.float "wbc_first_reading"
    t.date "wbc_first_reading_date"
    t.integer "platelet_first_reading"
    t.date "platelet_first_reading_date"
    t.integer "hct_second_reading"
    t.date "hct_second_reading_date"
    t.float "wbc_second_reading"
    t.date "wbc_second_reading_date"
    t.string "platelet_second_reading"
    t.date "platelet_second_reading_date"
    t.string "hct_third_reading"
    t.date "hct_third_reading_date"
    t.float "wbc_third_reading"
    t.date "wbc_third_reading_date"
    t.string "platelet_third_reading"
    t.date "platelet_third_reading_date"
    t.string "ns1"
    t.string "igg"
    t.string "igm"
    t.string "pcr"
    t.string "provisional_diagnosis"
    t.string "change_by"
    t.date "reporting_date"
    t.text "comments"
    t.string "patient_name"
    t.string "cnic"
    t.integer "patient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "passport"
    t.index ["patient_id"], name: "index_test_logs_on_patient_id"
  end

  create_table "tpv_audits", force: :cascade do |t|
    t.integer "department_id"
    t.string "department_name"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.date "audit_date"
    t.integer "district_id"
    t.string "district_name"
    t.text "activity_ids"
    t.string "category_name"
    t.string "audit_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "activity_type", default: 0
    t.integer "user_id"
    t.integer "user_department_id"
    t.string "dep_category"
    t.index ["category_name"], name: "index_tpv_audits_on_category_name"
    t.index ["department_id"], name: "index_tpv_audits_on_department_id"
    t.index ["district_id"], name: "index_tpv_audits_on_district_id"
    t.index ["tehsil_id"], name: "index_tpv_audits_on_tehsil_id"
  end

  create_table "u_towns", force: :cascade do |t|
    t.string "name"
    t.integer "townable_id"
    t.string "townable_type"
    t.integer "tehsil_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tehsil_name"
    t.index ["townable_id"], name: "index_u_towns_on_townable_id"
  end

  create_table "ucs", force: :cascade do |t|
    t.string "uc_name"
    t.integer "district_id"
    t.integer "tehsil_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "province_id"
  end

  create_table "user_categories", force: :cascade do |t|
    t.integer "mobile_user_id"
    t.integer "tag_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "sub_role"
    t.integer "lab_id"
    t.integer "role"
    t.integer "district_id"
    t.integer "hospital_id"
    t.integer "department_id"
    t.integer "tehsil_id"
    t.boolean "is_forgot", default: false
    t.boolean "status", default: true
    t.integer "old_user_id"
    t.boolean "hotspot_status"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "is_third_party_audit", default: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["district_id", "hospital_id"], name: "index_users_on_district_id_and_hospital_id"
    t.index ["district_id", "lab_id"], name: "index_users_on_district_id_and_lab_id"
    t.index ["district_id"], name: "index_users_on_district_id"
    t.index ["hospital_id"], name: "index_users_on_hospital_id"
    t.index ["lab_id"], name: "index_users_on_lab_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "workplace_addresses", force: :cascade do |t|
    t.integer "district_id"
    t.string "district_name"
    t.integer "tehsil_id"
    t.string "tehsil_name"
    t.integer "uc_id"
    t.string "uc_name"
    t.integer "gp_dengue_patient_id"
    t.text "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["district_id"], name: "index_workplace_addresses_on_district_id"
    t.index ["gp_dengue_patient_id"], name: "index_workplace_addresses_on_gp_dengue_patient_id"
    t.index ["tehsil_id"], name: "index_workplace_addresses_on_tehsil_id"
    t.index ["uc_id"], name: "index_workplace_addresses_on_uc_id"
  end

  create_table "zero_patients", force: :cascade do |t|
    t.integer "user_id"
    t.integer "hospital_id"
    t.string "hospital"
    t.integer "district_id"
    t.string "district"
    t.integer "t_type", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lab_id"
    t.string "lab"
    t.integer "province_id"
    t.index ["district_id"], name: "index_zero_patients_on_district_id"
    t.index ["hospital_id"], name: "index_zero_patients_on_hospital_id"
    t.index ["user_id"], name: "index_zero_patients_on_user_id"
  end

  add_foreign_key "motor_alert_locks", "motor_alerts", column: "alert_id"
  add_foreign_key "motor_alerts", "motor_queries", column: "query_id"
  add_foreign_key "motor_taggable_tags", "motor_tags", column: "tag_id"
end
