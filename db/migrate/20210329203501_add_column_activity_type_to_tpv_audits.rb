class AddColumnActivityTypeToTpvAudits < ActiveRecord::Migration[6.0]
  def change
    add_column :tpv_audits, :activity_type, :integer, default: 0
  end
end
