class AddUsersLastMonitored < ActiveRecord::Migration
  def up
    add_column :users, :monitored_at, :datetime,:after => :url
  end

  def down
    remove_column :users, :monitored_at
  end
end
