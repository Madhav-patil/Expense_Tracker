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

ActiveRecord::Schema[7.1].define(version: 2024_04_05_064743) do
  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.string "commentable_type", null: false
    t.integer "commentable_id", null: false
    t.integer "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["employee_id"], name: "index_comments_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "department"
    t.string "employment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "email"
  end

  create_table "expense_reports", force: :cascade do |t|
    t.string "name"
    t.integer "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.index ["employee_id"], name: "index_expense_reports_on_employee_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.date "date"
    t.text "description"
    t.decimal "amount"
    t.integer "employee_id", null: false
    t.integer "expense_report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_id"
    t.string "status"
    t.string "validation_message"
    t.decimal "reimbursement_amount"
    t.index ["employee_id"], name: "index_expenses_on_employee_id"
    t.index ["expense_report_id"], name: "index_expenses_on_expense_report_id"
  end

  add_foreign_key "comments", "employees"
  add_foreign_key "expense_reports", "employees"
  add_foreign_key "expenses", "employees"
  add_foreign_key "expenses", "expense_reports"
end
