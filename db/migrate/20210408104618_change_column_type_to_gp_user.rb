class ChangeColumnTypeToGpUser < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :gp_patients, :user_id, :gp_user_id
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
