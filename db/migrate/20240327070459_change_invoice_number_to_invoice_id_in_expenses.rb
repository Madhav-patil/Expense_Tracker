class ChangeInvoiceNumberToInvoiceIdInExpenses < ActiveRecord::Migration[7.1]
  def change
    rename_column :expenses, :invoice_number, :invoice_id
    change_column :expenses, :invoice_id, :integer
  end
end
