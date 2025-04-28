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

ActiveRecord::Schema[8.0].define(version: 2025_04_28_052003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "actions", force: :cascade do |t|
    t.bigint "near_transaction_id", null: false
    t.string "action_type"
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["near_transaction_id"], name: "index_actions_on_near_transaction_id"
  end

  create_table "near_transactions", force: :cascade do |t|
    t.datetime "external_time"
    t.bigint "external_height"
    t.string "external_hash"
    t.string "external_block_hash"
    t.string "external_sender"
    t.string "external_receiver"
    t.string "external_gas_burnt"
    t.integer "external_actions_count"
    t.boolean "external_success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "actions", "near_transactions"
end
