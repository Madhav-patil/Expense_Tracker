class RenameColumnsInExpenses < ActiveRecord::Migration[7.1]
  def change
    rename_column :expenses, :approval_status, :status
    rename_column :expenses, :approval_message, :validation_message
  end
end
