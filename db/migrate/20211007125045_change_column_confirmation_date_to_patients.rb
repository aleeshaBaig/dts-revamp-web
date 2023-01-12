class ChangeColumnConfirmationDateToPatients < ActiveRecord::Migration[6.0]
  def up
    change_column :patients, :confirmation_date, :datetime
    add_index :patients, :confirmation_date
  end
  def down
    change_column :patients, :confirmation_date, :date
    remove_index :patients, :confirmation_date
  end
end
