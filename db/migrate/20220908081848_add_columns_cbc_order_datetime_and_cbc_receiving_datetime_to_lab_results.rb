class AddColumnsCbcOrderDatetimeAndCbcReceivingDatetimeToLabResults < ActiveRecord::Migration[6.0]
  def change
    
    ## CBC Order date
    add_column :lab_results, :cbc_report_order_date_first, :datetime
    add_column :lab_results, :cbc_report_order_date_second, :datetime
    add_column :lab_results, :cbc_report_order_date_third, :datetime

    ## CBC Receiving date
    add_column :lab_results, :cbc_report_receiving_date_first, :datetime
    add_column :lab_results, :cbc_report_receiving_date_second, :datetime
    add_column :lab_results, :cbc_report_receiving_date_third, :datetime

    ## CBC Turnaround Time (Differentiate)
    add_column :lab_results, :cbc_turnaround_first, :integer
    add_column :lab_results, :cbc_turnaround_second, :integer
    add_column :lab_results, :cbc_turnaround_third, :integer

  end
end
