class ChangeWbcColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :lab_results, :wbc_first_reading, :float
    change_column :lab_results, :wbc_second_reading, :float
    change_column :lab_results, :wbc_third_reading, :float
  end
end
