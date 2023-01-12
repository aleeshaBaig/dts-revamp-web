class ChangeColumnMonthAgeYearToLabAptients < ActiveRecord::Migration[6.0]
  def up
  	remove_column :lab_patients, :age
  	remove_column :lab_patients, :month

  	add_column :lab_patients, :age, :integer
  	add_column :lab_patients, :month, :integer
  end
end
