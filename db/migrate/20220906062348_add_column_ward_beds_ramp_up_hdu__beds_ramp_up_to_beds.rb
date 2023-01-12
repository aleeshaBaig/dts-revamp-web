class AddColumnWardBedsRampUpHduBedsRampUpToBeds < ActiveRecord::Migration[6.0]
  def change
    add_column :beds, :ward_beds_ramp_up, :integer, default: 0
    add_column :beds, :hdu_beds_ramp_up, :integer, default: 0
  end
end
