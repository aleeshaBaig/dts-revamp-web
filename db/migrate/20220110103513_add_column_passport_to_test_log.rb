class AddColumnPassportToTestLog < ActiveRecord::Migration[6.0]
  def change
    add_column :test_logs, :passport, :string
  end
end
