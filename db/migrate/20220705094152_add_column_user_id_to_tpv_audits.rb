class AddColumnUserIdToTpvAudits < ActiveRecord::Migration[6.0]
  def change
    add_column :tpv_audits, :user_id, :integer
    add_column :tpv_audits, :user_department_id, :integer
  end
end
