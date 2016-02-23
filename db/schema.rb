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

ActiveRecord::Schema.define(version: 20160223173022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hashtags", force: :cascade do |t|
    t.integer  "image_id"
    t.text     "raw_related_hashtag"
    t.text     "related_hashtags"
    t.text     "related_hashtag_ids"
    t.integer  "total_count_on_ig"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "ig_media_id"
    t.datetime "ig_publish_time"
    t.integer  "number_of_likes", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "timeslots", force: :cascade do |t|
    t.integer  "hashtag_id"
    t.integer  "number_of_likes",  default: 0
    t.integer  "number_of_photos", default: 0
    t.string   "slot_name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.text     "auth_digest"
    t.string   "last_login_time"
    t.string   "uid"
    t.string   "ig_username"
    t.string   "ig_access_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
