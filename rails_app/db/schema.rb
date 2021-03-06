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

ActiveRecord::Schema.define(version: 20140705162312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "songs_count", default: 0
  end

  create_table "languages", force: :cascade do |t|
    t.string   "iso"
    t.string   "name"
    t.integer  "translations_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", force: :cascade do |t|
    t.string   "title"
    t.string   "composer"
    t.string   "lyricist"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "genre_id"
    t.integer  "translations_count", default: 0
    t.string   "search_title"
  end

  create_table "translations", force: :cascade do |t|
    t.string   "link"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id",   default: 1
    t.integer  "translator_id", default: 0
    t.boolean  "active",        default: true
  end

  add_index "translations", ["language_id"], name: "index_translations_on_language_id", using: :btree
  add_index "translations", ["song_id"], name: "index_translations_on_song_id", using: :btree

  create_table "translators", force: :cascade do |t|
    t.string   "name"
    t.string   "site_name"
    t.string   "site_link"
    t.integer  "translations_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
