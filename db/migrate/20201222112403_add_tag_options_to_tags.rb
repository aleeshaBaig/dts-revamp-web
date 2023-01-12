class AddTagOptionsToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :tag_options, :string
  end
end
