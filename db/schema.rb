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

ActiveRecord::Schema[7.0].define(version: 2023_02_10_033007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "auction_status", ["scheduled", "in_progress", "finished"]
  create_enum "transaction_kinds", ["bid", "deposit", "auction_gains", "refund"]

  create_table "arts", force: :cascade do |t|
    t.string "author"
    t.string "year"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_arts_on_user_id"
  end

  create_table "auctions", force: :cascade do |t|
    t.bigint "art_id", null: false
    t.string "description", default: "", null: false
    t.integer "minimal_bid"
    t.datetime "start_date"
    t.datetime "end_date"
    t.enum "status", enum_type: "auction_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["art_id"], name: "index_auctions_on_art_id"
  end

  create_table "bids", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.enum "kind", enum_type: "transaction_kinds"
    t.integer "value"
    t.string "origin_type", null: false
    t.bigint "origin_id", null: false
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["origin_type", "origin_id"], name: "index_transactions_on_origin"
    t.index ["target_type", "target_id"], name: "index_transactions_on_target"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "arts", "users"
  add_foreign_key "auctions", "arts"
end
