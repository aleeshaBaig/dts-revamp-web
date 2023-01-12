class AddColumnDepCategoryToTpvAudits < ActiveRecord::Migration[6.0]
  def change
    add_column :tpv_audits, :dep_category, :string
  end
end
