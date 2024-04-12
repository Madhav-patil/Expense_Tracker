class AddInvoiceNumberToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :invoice_number, :string
  end
end
