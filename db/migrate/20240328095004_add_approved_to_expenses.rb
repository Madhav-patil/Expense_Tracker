class AddApprovedToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :approved, :boolean
  end
end
