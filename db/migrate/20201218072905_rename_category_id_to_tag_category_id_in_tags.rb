class RenameCategoryIdToTagCategoryIdInTags < ActiveRecord::Migration[6.0]
  def up
  	rename_column :tags, :category_id, :tag_category_id
  end

  def down
  	rename_column :tags, :tag_category_id, :category_id
  end
end
