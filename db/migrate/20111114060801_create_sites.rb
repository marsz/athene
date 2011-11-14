class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :domain
      t.string :name
      t.string :url
      t.text :description
      t.integer :users_count, :defulat=>0
      t.integer :posts_count, :defulat=>0
      t.timestamps
    end
  end
end
