class CreateSurveillanceTags < ActiveRecord::Migration[6.0]
  def change
    create_table :surveillance_tags do |t|
      t.string :name
      t.string :tag_type

      t.timestamps
    end
  end
end
