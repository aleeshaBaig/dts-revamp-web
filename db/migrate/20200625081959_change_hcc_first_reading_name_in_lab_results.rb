class ChangeHccFirstReadingNameInLabResults < ActiveRecord::Migration[6.0]
  def change
  	rename_column :lab_results, :hcc_first_reading, :hct_first_reading

  end
end
