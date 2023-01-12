class AddColumnPictureableTagToPictures < ActiveRecord::Migration[6.0]
  def change
    add_column :pictures, :pictureable_tag, :string
  end
end
