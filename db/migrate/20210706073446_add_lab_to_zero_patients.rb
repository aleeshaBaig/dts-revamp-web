class AddLabToZeroPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :zero_patients, :lab, :string
  end
end
