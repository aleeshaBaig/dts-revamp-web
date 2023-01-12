class CreateTagOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_options do |t|
      t.string :option_name

      t.timestamps
    end
  end
end
