class AddStatusToExpenseReports < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_reports, :status, :string
  end
end
