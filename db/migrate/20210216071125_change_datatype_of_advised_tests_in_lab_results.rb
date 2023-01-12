class ChangeDatatypeOfAdvisedTestsInLabResults < ActiveRecord::Migration[6.0]
  def self.up
    change_table :lab_results do |t|
      t.change :advised_test, :text
    end
  end
  def self.down
    change_table :lab_results do |t|
      t.change :advised_test, :string
    end
  end
end
