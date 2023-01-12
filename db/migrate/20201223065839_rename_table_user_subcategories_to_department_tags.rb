class RenameTableUserSubcategoriesToDepartmentTags < ActiveRecord::Migration[6.0]
  def up
  	rename_table :user_subcategories, :department_tags
  end
end
