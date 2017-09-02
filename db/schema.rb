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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170823231226) do

  create_table "accounts", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.boolean "is_active", default: true
    t.integer "join_time"
    t.integer "login_time"
    t.string "language"
    t.string "email"
    t.string "joined_ip"
    t.string "logged_ip"
    t.integer "inviter"
    t.string "first_name"
    t.string "last_name"
    t.integer "gender", limit: 1
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "dialogs", force: :cascade do |t|
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "time"
    t.boolean "is_anon", default: false
    t.string "last_message"
    t.integer "last_writer_id"
    t.index ["account_id"], name: "index_dialogs_on_account_id"
    t.index ["last_writer_id"], name: "index_dialogs_on_last_writer_id"
  end

  create_table "user_dialogs", force: :cascade do |t|
    t.integer "account_id"
    t.integer "dialog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_user_dialogs_on_account_id"
    t.index ["dialog_id"], name: "index_user_dialogs_on_dialog_id"
  end

end
