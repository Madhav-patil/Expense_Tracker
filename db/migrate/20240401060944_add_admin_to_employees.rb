class AddAdminToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :admin, :boolean
  end
end
