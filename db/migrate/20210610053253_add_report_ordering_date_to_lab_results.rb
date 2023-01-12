class AddReportOrderingDateToLabResults < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_results, :report_ordering_date, :datetime
  end
end
