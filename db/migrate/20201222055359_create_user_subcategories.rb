class CreateUserSubcategories < ActiveRecord::Migration[6.0]
  def change
    create_table :user_subcategories do |t|
      t.integer :mobile_user_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
