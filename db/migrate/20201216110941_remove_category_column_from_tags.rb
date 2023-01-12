class RemoveCategoryColumnFromTags < ActiveRecord::Migration[6.0]
  def change
    remove_column :tags, :category, :string
  end
end
