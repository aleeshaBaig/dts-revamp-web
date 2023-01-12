class AddColumnConfirmationDateToLabPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_patients, :confirmation_date, :date
  end
end
