class AddColumnIsEnabledToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_enabled, :boolean, :after => :posts_count
    User.scoped.each do |u|
      u.enable
    end
  end
end
