class AddNameWidthToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name_width, :float
  end
end
