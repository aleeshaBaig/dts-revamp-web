class CreateMobileUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :mobile_users do |t|
      t.string :username
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
