class AddColumnAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string, :after => :url
  end
end
