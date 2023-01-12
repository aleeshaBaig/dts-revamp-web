class CreateTestLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :test_logs do |t|
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
      t.integer :patient_id

      t.timestamps
    end
    add_index :test_logs, :patient_id
  end
end
