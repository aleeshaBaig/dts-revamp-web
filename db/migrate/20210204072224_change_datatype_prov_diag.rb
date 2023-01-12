class ChangeDatatypeProvDiag < ActiveRecord::Migration[6.0]
  def changec
    change_column :lab_patients, :provisional_diagnosis, 'integer USING CAST(provisional_diagnosis AS integer)'
  end
end
