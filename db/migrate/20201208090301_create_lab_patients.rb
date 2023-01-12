class CreateLabPatients < ActiveRecord::Migration[6.0]
  def change
    create_table :lab_patients do |t|
      t.string :lab_name
      t.string :p_name
      t.string :fh_name
      t.string :age
      t.string :month
      t.string :gender
      t.string :occupation
      t.string :contact_no
      t.string :other_contact_no
      t.string :cnic
      t.string :cnic_type
      t.string :house_no
      t.string :street_no
      t.string :locality
      t.integer :district_id
      t.integer :tehsil_id
      t.integer :uc_id
      t.integer :hct_first_reading
      t.date :hct_first_reading_date
      t.integer :wbc_first_reading
      t.date :wbc_first_reading_date
      t.integer :platelet_first_reading
      t.date :platelet_first_reading_date
      t.integer :hct_second_reading
      t.date :hct_second_reading_date
      t.integer :wbc_second_reading
      t.date :wbc_second_reading_date
      t.string :platelet_second_reading
      t.date :platelet_second_reading_date
      t.string :hct_third_reading
      t.date :hct_third_reading_date
      t.string :wbc_third_reading
      t.date :wbc_third_reading_date
      t.string :platelet_third_reading
      t.date :platelet_third_reading_date
      t.string :ns_1
      t.string :igg
      t.string :igm
      t.string :pcr
      t.string :provisional_diagnosis

      t.timestamps
    end
  end
end
