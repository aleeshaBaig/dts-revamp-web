class ChangeColumnConfirmationDateToLabPatients < ActiveRecord::Migration[6.0]
  def up
    change_column :lab_patients, :confirmation_date, :datetime
    add_index :lab_patients, :confirmation_date
  end
  def down
    change_column :lab_patients, :confirmation_date, :date
    remove_index :lab_patients, :confirmation_date
  end

end
