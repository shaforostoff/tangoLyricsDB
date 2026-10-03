# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2014_07_05_162312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "genres", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "songs_count", default: 0
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "iso", limit: 255
    t.string "name", limit: 255
    t.integer "translations_count", default: 0
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "songs", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "composer", limit: 255
    t.string "lyricist", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "year"
    t.integer "genre_id"
    t.integer "translations_count", default: 0
    t.string "search_title", limit: 255
  end

  create_table "translations", id: :serial, force: :cascade do |t|
    t.string "link", limit: 255
    t.integer "song_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "language_id", default: 1
    t.integer "translator_id", default: 0
    t.boolean "active", default: true
    t.index ["language_id"], name: "index_translations_on_language_id"
    t.index ["song_id"], name: "index_translations_on_song_id"
  end

  create_table "translators", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "site_name", limit: 255
    t.string "site_link", limit: 255
    t.integer "translations_count", default: 0
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
