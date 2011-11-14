class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :site_id
      t.string :site_post_id
      t.string :title
      t.column :content, "LONGTEXT"
      t.date :date
      t.datetime :datetime
      t.text :url
      t.string :state
      t.timestamps
    end
  end
end
