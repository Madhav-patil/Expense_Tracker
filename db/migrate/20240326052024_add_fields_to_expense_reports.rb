class AddFieldsToExpenseReports < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_reports, :description, :text
    add_column :expense_reports, :start_date, :date
    add_column :expense_reports, :end_date, :date
  end
end
