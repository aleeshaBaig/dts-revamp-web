class AddColumnDivisionIdToMobileUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :mobile_users, :division_id, :integer
  end
end
