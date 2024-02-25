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

ActiveRecord::Schema[7.0].define(version: 2024_02_25_173426) do
  create_table "agencies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buyers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "user_metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "distributors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "name"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "fk_rails_216df4e8fd"
  end

  create_table "item_selling_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_type"
    t.bigint "item_id"
    t.bigint "agency_id"
    t.bigint "buyer_id"
    t.float "selling_price"
    t.string "selling_price_visibility_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "distributor_id"
    t.index ["agency_id"], name: "fk_rails_1d6f92d5e5"
    t.index ["buyer_id"], name: "fk_rails_65de868c7a"
    t.index ["distributor_id"], name: "fk_rails_7381df7ff8"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "item_type"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.index ["email"], name: "users_unique_email"
  end

  create_table "vehicle_models", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "company_name"
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "vehicle_model_id"
    t.string "registration_id"
    t.string "chassis_id"
    t.string "engine_id"
    t.integer "manufacturing_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agency_id"
    t.float "cost_price"
    t.string "cost_price_visibility_status"
    t.string "status"
    t.string "loan_or_agreement_number"
    t.string "stock_entry_date"
    t.text "comments"
    t.string "location"
    t.index ["agency_id"], name: "fk_rails_bc1c0879fa"
    t.index ["chassis_id"], name: "vehicles_unique_chassis_id"
    t.index ["engine_id"], name: "vehicles_unique_engine_id"
    t.index ["registration_id"], name: "vehicles_unique_registration_id"
    t.index ["vehicle_model_id"], name: "fk_rails_83f60c4d50"
  end

  add_foreign_key "distributors", "agencies"
  add_foreign_key "item_selling_records", "agencies"
  add_foreign_key "item_selling_records", "buyers"
  add_foreign_key "item_selling_records", "distributors"
  add_foreign_key "vehicles", "agencies"
  add_foreign_key "vehicles", "vehicle_models"
end
