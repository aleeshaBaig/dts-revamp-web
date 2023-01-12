class AddDepartmentIdToMobileUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :mobile_users, :department_id, :integer
  end
end
