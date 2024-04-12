class AddApprovalMessageToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :approval_message, :string
  end
end
