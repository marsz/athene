class CreateUsersMonitorParsers < ActiveRecord::Migration
  def change
    create_table :users_monitor_parsers do |t|
      t.string :label
      t.string :regex
      t.integer :site_id
      t.timestamps
    end
  end
end
