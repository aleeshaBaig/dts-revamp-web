class CreateTpvAudits < ActiveRecord::Migration[6.0]
  def change
    create_table :tpv_audits do |t|
      t.integer :department_id
      t.string :department_name
      t.integer :tehsil_id
      t.string :tehsil_name
      t.date :audit_date
      t.integer :district_id
      t.string :district_name
      t.text :activity_ids
      t.string :category_name
      t.string :audit_type

      t.timestamps
    end
    add_index :tpv_audits, :department_id
    add_index :tpv_audits, :tehsil_id
    add_index :tpv_audits, :district_id
    add_index :tpv_audits, :category_name
  end
end
