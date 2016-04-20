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

ActiveRecord::Schema.define(:version => 20120110105826) do

  create_table "hits_logs", :force => true do |t|
    t.integer  "tubity_link_id"
    t.string   "referer"
    t.string   "remote_ip"
    t.string   "remote_host"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_agent"
    t.string   "http_cookie"
  end

  add_index "hits_logs", ["tubity_link_id"], :name => "index_hits_logs_on_tubity_link_id"

  create_table "links_logs", :force => true do |t|
    t.integer  "tubity_link_id"
    t.binary   "compressed_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links_logs", ["tubity_link_id"], :name => "index_links_logs_on_tubity_link_id"

end
