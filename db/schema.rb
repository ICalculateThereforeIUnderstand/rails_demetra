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

ActiveRecord::Schema[7.0].define(version: 2023_01_06_163110) do
  create_table "adrese", id: { type: :integer, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "adresa", limit: 8
    t.integer "kodskladista", unsigned: true
  end

  create_table "autoris", id: { type: :integer, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "autor", limit: 40
    t.index ["autor"], name: "autor", type: :fulltext
  end

  create_table "bibliotekes", primary_key: "biblioteka_id", id: { type: :integer, limit: 1, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "biblioteka", limit: 40
    t.index ["biblioteka"], name: "biblioteka", type: :fulltext
  end

  create_table "knjiges", id: { type: :integer, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "naslov", limit: 128
    t.string "godina", limit: 4
    t.integer "cijena", limit: 2, unsigned: true
    t.integer "brojstranica", limit: 2, unsigned: true
    t.string "isbn", limit: 20
    t.integer "biblioteka_id", limit: 1, unsigned: true
    t.binary "slika"
    t.string "hash_kod", limit: 15
    t.index ["godina"], name: "godina"
    t.index ["naslov"], name: "autor", type: :fulltext
  end

  create_table "odabraneknjiges", id: { type: :integer, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "id_knjige", unsigned: true
  end

  create_table "skladista", id: { type: :integer, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "skladiste", limit: 128
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "veze1", id: { type: :integer, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "kodknjige", unsigned: true
    t.integer "kodadrese", unsigned: true
    t.integer "kolicina", unsigned: true
  end

  create_table "vezes", id: { type: :integer, unsigned: true }, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "kodautora"
    t.integer "kodknjige"
  end

end
