class AddReportingDateToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :reporting_date, :date
  end
end
