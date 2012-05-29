# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120529021553) do

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.string   "site_post_id"
    t.string   "title"
    t.text     "content",      :limit => 2147483647
    t.date     "date"
    t.datetime "datetime"
    t.text     "url"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["date"], :name => "index_posts_on_date"
  add_index "posts", ["site_id"], :name => "index_posts_on_site_id"
  add_index "posts", ["site_post_id", "user_id"], :name => "index_posts_on_site_post_id_and_user_id", :unique => true
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "sites", :force => true do |t|
    t.string   "domain"
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.integer  "users_count"
    t.integer  "posts_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "site_user_id"
    t.integer  "site_id"
    t.string   "name"
    t.text     "url"
    t.string   "avatar"
    t.datetime "monitored_at"
    t.datetime "checked_at"
    t.string   "check_state",            :default => "idle"
    t.integer  "posts_count"
    t.string   "posts_monitoring_state"
    t.boolean  "is_enabled"
    t.boolean  "is_black"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["posts_monitoring_state"], :name => "index_users_on_posts_monitoring_state"
  add_index "users", ["site_id", "site_user_id"], :name => "index_users_on_site_id_and_site_user_id", :unique => true
  add_index "users", ["site_id"], :name => "index_users_on_site_id"

  create_table "users_monitor_parsers", :force => true do |t|
    t.string   "label"
    t.string   "regex"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_monitor_urls", :force => true do |t|
    t.text     "url"
    t.integer  "parser_id"
    t.string   "label"
    t.integer  "site_id"
    t.datetime "monitored_at"
    t.boolean  "is_enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
