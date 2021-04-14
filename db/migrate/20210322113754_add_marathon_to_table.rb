class AddMarathonToTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :tables, :marathon, null: false, foreign_key: true
  end
end
