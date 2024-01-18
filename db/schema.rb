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

ActiveRecord::Schema[7.1].define(version: 2024_01_18_082413) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "admin_user_type"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "buy_order_items", force: :cascade do |t|
    t.bigint "buy_order_id", null: false
    t.bigint "type_id", null: false
    t.integer "quantity"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buy_order_id"], name: "index_buy_order_items_on_buy_order_id"
    t.index ["type_id"], name: "index_buy_order_items_on_type_id"
  end

  create_table "buy_orders", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.decimal "price"
    t.datetime "order_date"
    t.datetime "delivery_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_price"
    t.index ["supplier_id"], name: "index_buy_orders_on_supplier_id"
  end

  create_table "other_expenses", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.bigint "buy_order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buy_order_id"], name: "index_other_expenses_on_buy_order_id"
  end

  create_table "other_sell_expenses", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.bigint "sell_order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sell_order_id"], name: "index_other_sell_expenses_on_sell_order_id"
  end

  create_table "sell_order_items", force: :cascade do |t|
    t.bigint "sell_order_id", null: false
    t.bigint "type_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sell_order_id"], name: "index_sell_order_items_on_sell_order_id"
    t.index ["type_id"], name: "index_sell_order_items_on_type_id"
  end

  create_table "sell_orders", force: :cascade do |t|
    t.bigint "shopkeeper_id", null: false
    t.decimal "total_price"
    t.datetime "sell_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price"
    t.index ["shopkeeper_id"], name: "index_sell_orders_on_shopkeeper_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "shopkeeper_dues_auto_reminder", default: false
    t.integer "reminder_send_time"
    t.integer "again_reminder_send_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopkeeper_tranctions", force: :cascade do |t|
    t.bigint "shopkeeper_id"
    t.bigint "sell_order_id"
    t.decimal "credit_amount"
    t.datetime "tranction_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sell_order_id"], name: "index_shopkeeper_tranctions_on_sell_order_id"
    t.index ["shopkeeper_id"], name: "index_shopkeeper_tranctions_on_shopkeeper_id"
  end

  create_table "shopkeepers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "dues_reminder_send_at"
  end

  create_table "supplier_tranctions", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "buy_order_id"
    t.decimal "debit_amount"
    t.datetime "tranction_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buy_order_id"], name: "index_supplier_tranctions_on_buy_order_id"
    t.index ["supplier_id"], name: "index_supplier_tranctions_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "comment"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.string "capacity"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 0
    t.integer "damage", default: 0
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "buy_order_items", "buy_orders"
  add_foreign_key "buy_order_items", "types"
  add_foreign_key "buy_orders", "suppliers"
  add_foreign_key "other_expenses", "buy_orders"
  add_foreign_key "other_sell_expenses", "sell_orders"
  add_foreign_key "sell_order_items", "sell_orders"
  add_foreign_key "sell_order_items", "types"
  add_foreign_key "sell_orders", "shopkeepers"
  add_foreign_key "shopkeeper_tranctions", "sell_orders"
  add_foreign_key "shopkeeper_tranctions", "shopkeepers"
  add_foreign_key "supplier_tranctions", "buy_orders"
  add_foreign_key "supplier_tranctions", "suppliers"
end
