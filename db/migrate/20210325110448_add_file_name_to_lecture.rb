class AddFileNameToLecture < ActiveRecord::Migration[6.0]
  def change
    add_column :lectures, :file_name, :string
  end
end
