class AddColumnStateMonitoringPostsToUser < ActiveRecord::Migration
  def change
    add_column :users, :posts_monitoring_state, :string, :after => :posts_count
    add_index :users, [:posts_monitoring_state]
  end
end
