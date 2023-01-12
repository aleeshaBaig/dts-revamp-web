class AddColumnReportingDateLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :reporting_date, :date
  end
end
