class ChangeMobileUserIdToDepartmentIdInUserSubcategories < ActiveRecord::Migration[6.0]
  def up
    rename_column :user_subcategories, :mobile_user_id, :department_id
  end
  def down
  	rename_column :user_subcategories, :department_id, :mobile_user_id
  end
end
