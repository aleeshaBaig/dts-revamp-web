class AddColumnPassportToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :passport, :string
    add_index :patients, :passport
  end
end
