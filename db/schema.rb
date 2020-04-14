# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_13_234414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "est_time"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "category_activities", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "activity_id", null: false
    t.index ["activity_id"], name: "index_category_activities_on_activity_id"
    t.index ["category_id"], name: "index_category_activities_on_category_id"
  end

  create_table "event_schedules", force: :cascade do |t|
    t.string "event_name"
    t.datetime "event_start_time"
    t.datetime "event_end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_event_schedules_on_user_id"
  end

  create_table "user_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_activity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_activity_id"], name: "index_user_activities_on_category_activity_id"
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "google_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "self_care_time"
  end

  add_foreign_key "category_activities", "activities"
  add_foreign_key "category_activities", "categories"
  add_foreign_key "event_schedules", "users"
  add_foreign_key "user_activities", "category_activities"
  add_foreign_key "user_activities", "users"
end
