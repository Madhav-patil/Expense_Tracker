class AddReimbursementAmountToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :reimbursement_amount, :decimal
  end
end
