class CreateUserCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_categories do |t|
      t.integer :mobile_user_id
      t.integer :tag_category_id

      t.timestamps
    end
  end
end
