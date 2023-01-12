class AddColumnIsSurveillanceToMobileUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :mobile_users, :is_surveillance, :boolean, default: false
  end
end
