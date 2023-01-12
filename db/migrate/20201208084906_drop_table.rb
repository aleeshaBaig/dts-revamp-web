class DropTable < ActiveRecord::Migration[6.0]
  def change
  	ActiveRecord::Base.connection.execute("drop table lab_patients")
  end
end
