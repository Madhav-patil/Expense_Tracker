class AddDefaultToAdminInEmployees < ActiveRecord::Migration[7.1]
  def change
    change_column_default :employees, :admin, from: nil, to: false
  end
end
