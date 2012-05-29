class AddColumnIsBlackToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_black, :boolean, :after => :is_enabled, :default => false
    User.find_each{ |u| u.update_column :is_black, false }
  end
end
