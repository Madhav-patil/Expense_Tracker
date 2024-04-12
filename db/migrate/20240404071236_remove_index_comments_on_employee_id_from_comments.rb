class RemoveIndexCommentsOnEmployeeIdFromComments < ActiveRecord::Migration[7.1]
  def change
    def change
      remove_index :comments, name: "index_comments_on_employee_id"
    end
  end
end
