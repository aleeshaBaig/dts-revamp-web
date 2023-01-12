class AddLocationDetailsToMobileUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :mobile_users, :town, :string
    add_column :mobile_users, :town_id, :integer
    add_column :mobile_users, :district, :string
    add_column :mobile_users, :district_id, :integer
    add_column :mobile_users, :uc, :string
    add_column :mobile_users, :uc_id, :integer
  end
end
