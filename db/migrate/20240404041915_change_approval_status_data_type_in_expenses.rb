class ChangeApprovalStatusDataTypeInExpenses < ActiveRecord::Migration[7.1]
  def change
    change_column :expenses, :approval_status, :string
  end
end
