class AddColumnUrduToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :urdu, :string
  end
end
