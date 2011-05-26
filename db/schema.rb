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

ActiveRecord::Schema.define(:version => 20110526141902) do

  create_table "assets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uploaded_file_file_name"
    t.string   "uploaded_file_content_type"
    t.integer  "uploaded_file_file_size"
    t.datetime "uploaded_file_updated_at"
    t.integer  "folder_id"
    t.text     "description"
    t.text     "notes"
    t.integer  "user_id"
  end

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "notes"
    t.integer  "user_id"
  end

  add_index "folders", ["parent_id"], :name => "index_folders_on_parent_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hotlinks", :force => true do |t|
    t.integer  "asset_id"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "link"
    t.datetime "expiry_date"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "assigned_by"
    t.boolean  "read_perms",   :default => false
    t.boolean  "write_perms",  :default => false
    t.boolean  "delete_perms", :default => false
    t.integer  "folder_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "name"
    t.boolean  "active",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quota"
  end

end
