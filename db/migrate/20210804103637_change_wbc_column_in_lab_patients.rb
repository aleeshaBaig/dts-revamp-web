class ChangeWbcColumnInLabPatients < ActiveRecord::Migration[6.0]
  def change
    execute 'ALTER TABLE lab_patients ALTER COLUMN wbc_third_reading TYPE float USING (wbc_third_reading::float)'
  end
end
