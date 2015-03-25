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

ActiveRecord::Schema.define(version: 20150324131435) do

  create_table "categories", force: true do |t|
    t.string   "forsquare_id"
    t.string   "string"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighbourhoods", force: true do |t|
    t.string   "name"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venue_categories", force: true do |t|
    t.integer  "venue_id"
    t.integer  "category_id"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", force: true do |t|
    t.string   "forsquare_id"
    t.string   "name"
    t.string   "phone"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "facebook_name"
    t.string   "checkins_count"
    t.string   "tips_count"
    t.string   "users_count"
    t.text     "url"
    t.string   "store_id"
    t.string   "referal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "lat"
    t.string   "lang"
    t.string   "distance"
    t.string   "postal_code"
    t.string   "cc"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "google_id"
  end

end