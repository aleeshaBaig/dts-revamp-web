class AddColumnMobileApiIds < ActiveRecord::Migration[6.0]
  def change
  	add_column :tag_categories, :m_category_id, :integer
  	add_column :tag_options, :m_option_id, :integer
  	add_column :tags, :m_tag_id, :integer
  	add_column :tags, :m_category_id, :integer

  	add_column :tag_categories, :category_name_en, :string
  	add_column :tags, :tag_name_en, :string
  end
end
