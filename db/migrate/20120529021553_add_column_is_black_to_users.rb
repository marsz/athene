class AddColumnIsBlackToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_black, :boolean, :after => :is_enabled
  end
end
