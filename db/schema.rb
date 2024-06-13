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

ActiveRecord::Schema[7.1].define(version: 2024_06_13_170505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connected_neighbors", id: false, force: :cascade do |t|
    t.bigint "node_id", null: false
    t.bigint "connected_neighbor_id", null: false
    t.index ["connected_neighbor_id", "node_id"], name: "index_connected_neighbors_on_connected_neighbor_id_and_node_id", unique: true
    t.index ["node_id", "connected_neighbor_id"], name: "index_connected_neighbors_on_node_id_and_connected_neighbor_id", unique: true
  end

  create_table "mazes", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "initial_coordinate"
    t.jsonb "goal_coordinate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_mazes_on_name", unique: true
  end

  create_table "neighbors", id: false, force: :cascade do |t|
    t.bigint "node_id", null: false
    t.bigint "neighbor_id", null: false
    t.index ["neighbor_id", "node_id"], name: "index_neighbors_on_neighbor_id_and_node_id", unique: true
    t.index ["node_id", "neighbor_id"], name: "index_neighbors_on_node_id_and_neighbor_id", unique: true
  end

  create_table "nodes", force: :cascade do |t|
    t.integer "maze_id", null: false
    t.integer "color", default: 0
    t.jsonb "coordinate"
    t.jsonb "position"
    t.bigint "parent_node_id"
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "borders"
    t.integer "ans_color", default: 0
    t.index ["parent_node_id"], name: "index_nodes_on_parent_node_id"
  end

  add_foreign_key "nodes", "nodes", column: "parent_node_id"
end
