class DropComments < ActiveRecord::Migration[7.1]
  def change
    drop_table :comments
  end
end
