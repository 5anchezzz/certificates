class AddWidthHeightToLecture < ActiveRecord::Migration[6.0]
  def change
    add_column :lectures, :pdf_width, :integer
    add_column :lectures, :pdf_height, :integer
  end
end
