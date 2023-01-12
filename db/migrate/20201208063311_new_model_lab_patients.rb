class NewModelLabPatients < ActiveRecord::Migration[6.0]
  def change
  	ActiveRecord::Base.connection.execute("create table lab_patients as
  select * from patients
with no data")
  end
end
