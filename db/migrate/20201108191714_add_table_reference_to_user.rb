class AddTableReferenceToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :table, null: true, foreign_key: true
  end
end
