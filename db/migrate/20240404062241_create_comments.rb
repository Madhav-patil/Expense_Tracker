class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :commentable, polymorphic: true, null: false
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
