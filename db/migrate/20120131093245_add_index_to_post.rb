class AddIndexToPost < ActiveRecord::Migration
  def change
    remove_index :posts, [:site_id,:site_post_id]
    add_index :posts, [:site_post_id,:user_id], :unique => true
  end
end
