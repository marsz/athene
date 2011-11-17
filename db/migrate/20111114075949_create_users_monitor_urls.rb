class CreateUsersMonitorUrls < ActiveRecord::Migration
  def change
    create_table :users_monitor_urls do |t|
      t.text :url
      t.integer :parser_id
      t.string :label
      t.integer :site_id
      t.datetime :monitored_at
      t.boolean :is_enabled
      t.timestamps
    end
  end
end
