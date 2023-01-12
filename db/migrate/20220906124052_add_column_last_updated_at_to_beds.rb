class AddColumnLastUpdatedAtToBeds < ActiveRecord::Migration[6.0]
  def change
    add_column :beds, :last_updated_at, :datetime
  end
end
