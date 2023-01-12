class AddColumnUrduToTagCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :tag_categories, :urdu, :string
  end
end
