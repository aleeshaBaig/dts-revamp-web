class AddAdvisedTestToLabResults < ActiveRecord::Migration[6.0]
  def change
    add_column :lab_results, :advised_test, :string
  end
end
