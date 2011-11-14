class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :site_user_id
      t.integer :site_id
      t.string :name
      t.text :url
      t.integer :posts_count, :defulat=>0
      t.timestamps
    end
  end
end
