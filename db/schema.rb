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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150713140703) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id"

  create_table "blacklists", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "bother_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string   "title",                     null: false
    t.integer  "isbn",            limit: 8
    t.string   "author"
    t.string   "manufacturer"
    t.integer  "genre_id"
    t.string   "cover_image_url"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "bookshelves", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "book_id",     null: false
    t.integer  "borrower_id", null: false
    t.integer  "rate"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "borrows", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "book_id",    null: false
    t.integer  "lender_id",  null: false
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friends", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.boolean  "accepted",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genrelists", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "genre_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "sender_id",  null: false
    t.integer  "book_id",    null: false
    t.boolean  "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "userids", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "firstname",       null: false
    t.string   "lastname",        null: false
    t.string   "school"
    t.integer  "lend_num"
    t.integer  "borrow_num"
    t.string   "invitation_code", null: false
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
