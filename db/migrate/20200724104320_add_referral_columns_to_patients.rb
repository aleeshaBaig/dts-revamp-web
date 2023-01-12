class AddReferralColumnsToPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :referred_to_id, :integer
    add_column :patients, :referred_to, :string
    add_column :patients, :referred_from_id, :integer
    add_column :patients, :referred_reason, :string
    add_column :patients, :currently_referred, :boolean
  end
end
