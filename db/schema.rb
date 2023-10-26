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

ActiveRecord::Schema[7.0].define(version: 2023_10_26_060755) do
  create_table "cargos", force: :cascade do |t|
    t.integer "order_id"
    t.integer "truck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_weight_lbs"
    t.integer "total_volume_cubic_feet"
    t.float "pallet_per_truck"
    t.float "pallet_cost_per_mile"
    t.float "std_package_per_truck"
    t.float "std_package_cost_per_mile"
    t.index ["order_id"], name: "index_cargos_on_order_id"
    t.index ["truck_id"], name: "index_cargos_on_truck_id"
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.integer "client_id"
    t.integer "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["destination_id"], name: "index_orders_on_destination_id"
    t.index ["origin_id"], name: "index_orders_on_origin_id"
    t.index ["route_id"], name: "index_orders_on_route_id"
  end

  create_table "packages", force: :cascade do |t|
    t.integer "volume"
    t.integer "weight"
    t.string "package_type"
    t.integer "cargo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cargo_id"], name: "index_packages_on_cargo_id"
  end

  create_table "routes", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anchor_point"
    t.float "miles_with_cargo"
    t.float "total_miles"
    t.float "operational_truck_cost"
    t.integer "pallets"
    t.float "cargo_cost"
    t.float "empty_cargo_cost"
    t.float "markup"
    t.float "price_based_on_total_cost"
    t.float "price_based_on_cargo_cost"
    t.float "margin"
    t.integer "pickup_dropoff_qty"
    t.float "time_hours"
    t.string "contract_name"
    t.index ["destination_id"], name: "index_routes_on_destination_id"
    t.index ["origin_id"], name: "index_routes_on_origin_id"
  end

  create_table "trucks", force: :cascade do |t|
    t.boolean "autonomy"
    t.integer "capacity"
    t.string "truck_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_costs_per_mile"
    t.float "trucker_cost"
    t.float "fuel_cost"
    t.float "leasing_cost"
    t.float "maintenance_cost"
    t.float "insurance_cost"
    t.float "miles_per_gallon"
    t.float "gas_price"
    t.float "avg_speed_miles_per_hour"
    t.integer "route_id"
    t.index ["route_id"], name: "index_trucks_on_route_id"
  end

  add_foreign_key "cargos", "orders"
  add_foreign_key "cargos", "trucks"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "locations", column: "destination_id"
  add_foreign_key "orders", "locations", column: "origin_id"
  add_foreign_key "orders", "routes"
  add_foreign_key "packages", "cargos"
  add_foreign_key "routes", "locations", column: "destination_id"
  add_foreign_key "routes", "locations", column: "origin_id"
end
