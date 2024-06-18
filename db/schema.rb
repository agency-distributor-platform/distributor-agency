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

ActiveRecord::Schema[7.0].define(version: 2024_06_18_075016) do
  create_table "agencies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.string "city"
    t.string "state"
    t.integer "pincode"
    t.index ["email"], name: "agencies_unique_email", unique: true
  end

  create_table "booking_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "booking_price"
    t.string "booking_persona_type"
    t.bigint "transaction_id"
    t.index ["transaction_id"], name: "fk_rails_51a0d5c5c2"
  end

  create_table "buyers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "user_metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.string "city"
    t.string "state"
    t.integer "pincode"
    t.string "addhar"
    t.string "pan"
    t.string "father_name"
    t.string "mother_name"
  end

  create_table "distributors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "agency_id"
    t.string "name"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "phone"
    t.text "address"
    t.string "city"
    t.string "state"
    t.integer "pincode"
    t.index ["agency_id"], name: "fk_rails_216df4e8fd"
    t.index ["email"], name: "distributors_unique_email", unique: true
  end

  create_table "inquiries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "vehicle_model"
    t.float "starting_price"
    t.float "ending_price"
    t.text "comments"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "agency_id"
    t.string "name"
    t.string "email"
    t.bigint "phone"
    t.index ["agency_id"], name: "fk_rails_6a64f6ed3a"
  end

  create_table "item_mapping_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_type"
    t.bigint "item_id"
    t.bigint "agency_id"
    t.bigint "buyer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "distributor_id"
    t.bigint "salesperson_id"
    t.integer "salesperson_share"
    t.integer "distributor_share"
    t.bigint "status_id"
    t.index ["agency_id"], name: "fk_rails_1d6f92d5e5"
    t.index ["buyer_id"], name: "fk_rails_65de868c7a"
    t.index ["distributor_id"], name: "fk_rails_7381df7ff8"
    t.index ["status_id"], name: "fk_rails_5a66de9fe6"
  end

  create_table "prospect_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "mode"
    t.bigint "vehicle_model_id"
    t.integer "manufactoring_year"
    t.text "comments"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "refer_persona_type"
    t.bigint "refer_persona_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vehicle_model_id"], name: "fk_rails_6607bed03c"
  end

  create_table "salespersons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.string "city"
    t.string "state"
    t.integer "pincode"
  end

  create_table "selling_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "selling_price"
    t.float "due_price"
    t.string "selling_persona_type"
    t.bigint "transaction_id"
    t.index ["transaction_id"], name: "fk_rails_bcc972863e"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
  end

  create_table "statuses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "item_mapping_record_id"
    t.datetime "transaction_date"
    t.string "payment_transaction_id"
    t.index ["item_mapping_record_id"], name: "fk_rails_bd2cf037af"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "employer_type"
    t.bigint "employer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.index ["employer_type", "email"], name: "users_unique_employer_type_email"
  end

  create_table "vehicle_models", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "company_name"
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "manufactoring_year"
    t.index ["company_name", "model"], name: "vehicle_models_unique_company_name_model", unique: true
  end

  create_table "vehicles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "vehicle_model_id"
    t.string "registration_id"
    t.string "chassis_id"
    t.string "engine_id"
    t.integer "manufacturing_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "cost_price"
    t.string "loan_or_agreement_number"
    t.string "stock_entry_date"
    t.text "comments"
    t.string "location"
    t.string "city"
    t.string "state"
    t.integer "pincode"
    t.string "google_drive_folder_id"
    t.float "expenses"
    t.string "fin_company_name"
    t.bigint "kms_driven"
    t.index ["chassis_id"], name: "vehicles_unique_chassis_id", unique: true
    t.index ["engine_id"], name: "vehicles_unique_engine_id", unique: true
    t.index ["registration_id"], name: "vehicles_unique_registration_id", unique: true
    t.index ["vehicle_model_id"], name: "fk_rails_83f60c4d50"
  end

  add_foreign_key "booking_transactions", "transactions"
  add_foreign_key "distributors", "agencies"
  add_foreign_key "inquiries", "agencies"
  add_foreign_key "item_mapping_records", "agencies"
  add_foreign_key "item_mapping_records", "buyers"
  add_foreign_key "item_mapping_records", "distributors"
  add_foreign_key "item_mapping_records", "statuses"
  add_foreign_key "prospect_users", "vehicle_models"
  add_foreign_key "selling_transactions", "transactions"
  add_foreign_key "transactions", "item_mapping_records"
  add_foreign_key "vehicles", "vehicle_models"
end
