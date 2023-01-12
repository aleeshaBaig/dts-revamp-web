class AddReadingDateColumnsToLabResults < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_results, :hct_first_reading_date, :date
    add_column :lab_results, :hct_second_reading_date, :date
    add_column :lab_results, :hct_third_reading_date, :date
    add_column :lab_results, :hct_third_reading, :integer
    add_column :lab_results, :wbc_first_reading_date, :date
    add_column :lab_results, :wbc_second_reading_date, :date
    add_column :lab_results, :wbc_third_reading_date, :date
    add_column :lab_results, :wbc_third_reading, :integer
    add_column :lab_results, :platelet_first_reading_date, :date
    add_column :lab_results, :platelet_second_reading_date, :date
    add_column :lab_results, :platelet_third_reading_date, :date
    add_column :lab_results, :platelet_third_reading, :integer
  end
end
