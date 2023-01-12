class AddColumnIsThirdPartyAuditToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_third_party_audit, :boolean, default: false
  end
end
