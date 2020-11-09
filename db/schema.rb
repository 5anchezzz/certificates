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

ActiveRecord::Schema.define(version: 2020_11_08_192043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "certificates", force: :cascade do |t|
    t.string "name"
    t.string "speaker"
    t.text "description"
    t.date "date"
    t.string "language"
    t.integer "xpos"
    t.integer "ypos"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "template_file_name"
    t.string "template_content_type"
    t.integer "template_file_size"
    t.datetime "template_updated_at"
  end

  create_table "eng_templates", force: :cascade do |t|
    t.bigint "certificate_id", null: false
    t.integer "xpos"
    t.integer "ypos"
    t.string "font_color"
    t.integer "font_size"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pdf_file_file_name"
    t.string "pdf_file_content_type"
    t.integer "pdf_file_file_size"
    t.datetime "pdf_file_updated_at"
    t.index ["certificate_id"], name: "index_eng_templates_on_certificate_id"
  end

  create_table "rus_templates", force: :cascade do |t|
    t.bigint "certificate_id", null: false
    t.integer "xpos"
    t.integer "ypos"
    t.string "font_color"
    t.integer "font_size"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pdf_file_file_name"
    t.string "pdf_file_content_type"
    t.integer "pdf_file_file_size"
    t.datetime "pdf_file_updated_at"
    t.index ["certificate_id"], name: "index_rus_templates_on_certificate_id"
  end

  create_table "tables", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.text "description"
    t.text "logs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "doc_file_name"
    t.string "doc_content_type"
    t.integer "doc_file_size"
    t.datetime "doc_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "language"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "table_id"
    t.index ["table_id"], name: "index_users_on_table_id"
  end

  add_foreign_key "eng_templates", "certificates"
  add_foreign_key "rus_templates", "certificates"
  add_foreign_key "users", "tables"
end
