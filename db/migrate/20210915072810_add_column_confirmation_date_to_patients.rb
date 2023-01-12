class AddColumnConfirmationDateToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :confirmation_date, :date
  end
end
