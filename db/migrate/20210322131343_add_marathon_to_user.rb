class AddMarathonToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :marathon, null: false, foreign_key: true
  end
end
