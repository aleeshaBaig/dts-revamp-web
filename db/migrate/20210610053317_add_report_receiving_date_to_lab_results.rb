class AddReportReceivingDateToLabResults < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_results, :report_receiving_date, :datetime
  end
end
