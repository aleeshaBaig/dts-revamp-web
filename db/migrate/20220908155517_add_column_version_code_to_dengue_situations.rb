class AddColumnVersionCodeToDengueSituations < ActiveRecord::Migration[6.0]
  def change
    add_column :dengue_situations, :version_code, :integer
  end
end
