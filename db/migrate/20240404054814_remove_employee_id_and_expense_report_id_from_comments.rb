class RemoveEmployeeIdAndExpenseReportIdFromComments < ActiveRecord::Migration[7.1]
  def change
    remove_column :comments, :employee_id
    remove_column :comments, :expense_report_id
  end
end
