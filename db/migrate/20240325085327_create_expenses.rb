class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.date :date
      t.text :description
      t.decimal :amount
      t.references :employee, null: false, foreign_key: true
      t.references :expense_report, foreign_key: true

      t.timestamps
    end
  end
end
