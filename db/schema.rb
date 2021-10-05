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

ActiveRecord::Schema.define(version: 2021_09_30_032427) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cat_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cat_personalities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cat_id"
    t.integer "cat_personality_category_id"
    t.index ["cat_id"], name: "index_cat_personalities_on_cat_id"
    t.index ["cat_personality_category_id"], name: "index_cat_personalities_on_cat_personality_category_id"
  end

  create_table "cat_personality_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cat_sand_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cats", force: :cascade do |t|
    t.string "name"
    t.date "birthday"
    t.string "gender"
    t.float "weight"
    t.integer "food_amount"
    t.integer "pee_count"
    t.integer "poop_count"
    t.string "favorite_snack"
    t.string "favorite_toy"
    t.string "hospital"
    t.string "characteristic"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cat_category_id"
    t.integer "cat_sand_category_id"
    t.integer "family_id"
    t.index ["cat_category_id"], name: "index_cats_on_cat_category_id"
    t.index ["cat_sand_category_id"], name: "index_cats_on_cat_sand_category_id"
    t.index ["family_id"], name: "index_cats_on_family_id"
  end

  create_table "daily_record_types", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_records", force: :cascade do |t|
    t.integer "daily_record_type_id"
    t.integer "count"
    t.integer "amount"
    t.string "status"
    t.float "weight"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_daily_record_id"
    t.index ["daily_record_type_id"], name: "index_daily_records_on_daily_record_type_id"
    t.index ["target_daily_record_id"], name: "index_daily_records_on_target_daily_record_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.string "family_unique_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hospital_post_types", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hospital_posts", force: :cascade do |t|
    t.integer "cat_id"
    t.integer "user_id"
    t.string "title"
    t.text "content"
    t.integer "hospital_post_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cat_id"], name: "index_hospital_posts_on_cat_id"
    t.index ["hospital_post_type_id"], name: "index_hospital_posts_on_hospital_post_type_id"
    t.index ["user_id"], name: "index_hospital_posts_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "family_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_invitations_on_family_id"
  end

  create_table "target_daily_records", force: :cascade do |t|
    t.integer "cat_id"
    t.integer "user_id"
    t.date "target_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cat_id"], name: "index_target_daily_records_on_cat_id"
    t.index ["user_id"], name: "index_target_daily_records_on_user_id"
  end

  create_table "user_icons", force: :cascade do |t|
    t.string "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.integer "user_icon_id"
    t.boolean "host_user", default: false, null: false
    t.integer "family_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["family_id"], name: "index_users_on_family_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_icon_id"], name: "index_users_on_user_icon_id"
  end

end
