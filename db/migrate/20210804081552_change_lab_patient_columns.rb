class ChangeLabPatientColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :lab_patients, :wbc_first_reading, :float
    change_column :lab_patients, :wbc_second_reading, :float
  end
end
