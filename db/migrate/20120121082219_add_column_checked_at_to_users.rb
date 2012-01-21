class AddColumnCheckedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :checked_at, :datetime, :after => :monitored_at
  end
end
