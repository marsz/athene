class AddIndexToUsersAndPosts < ActiveRecord::Migration
  def change
    add_index :posts, [:site_id,:site_post_id], :unique => true
    add_index :users, [:site_id,:site_user_id], :unique => true
    add_index :posts, [:user_id]
    add_index :posts, [:site_id]
    add_index :posts, [:date]
    add_index :users, [:site_id]
  end
end
