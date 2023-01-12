class AddColumnLabTurnaroundTimeToLabResults < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_results, :lab_turnaround_time, :integer
  end
end
