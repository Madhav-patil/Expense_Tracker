class RenameApprovedColumnInExpenses < ActiveRecord::Migration[7.1]
  def change
    rename_column :expenses, :approved, :approval_status
  end
end
