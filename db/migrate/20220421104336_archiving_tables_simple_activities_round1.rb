class ArchivingTablesSimpleActivitiesRound1 < ActiveRecord::Migration[6.0]
  def up
    ## Move 21 Year data
    execute "create table archived21_simple_activities ( like simple_activities INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES);" 
    execute "insert into archived21_simple_activities (SELECT * FROM simple_activities WHERE DATE(created_at) >= '2021-07-02' and DATE(created_at) <= '2021-12-31');"
  
    ## Move 22 Year data
    execute "create table archived22_simple_activities ( like simple_activities INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES);" 
    execute "insert into archived22_simple_activities (SELECT * FROM simple_activities WHERE DATE(created_at) >= '2022-01-01');"
    ## simple activities table rename 
    execute "ALTER TABLE simple_activities RENAME TO old_simple_activities;"
    ## archive 22 to simple activities
    execute "ALTER TABLE archived22_simple_activities RENAME TO simple_activities;"
  end

  def down
    execute "DROP TABLE archived21_simple_activities"
    execute "DROP TABLE simple_activities"
    execute "ALTER TABLE old_simple_activities RENAME TO simple_activities;"

  end
end