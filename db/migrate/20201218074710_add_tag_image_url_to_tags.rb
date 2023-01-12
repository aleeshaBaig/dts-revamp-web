class AddTagImageUrlToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :tag_image_url, :string
  end
end
