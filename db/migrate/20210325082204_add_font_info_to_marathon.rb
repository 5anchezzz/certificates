class AddFontInfoToMarathon < ActiveRecord::Migration[6.0]
  def change
    add_column :marathons, :pdf_width, :integer
    add_column :marathons, :pdf_height, :integer
    add_column :marathons, :font_size, :integer
    add_column :marathons, :font_color, :string
    add_column :marathons, :x_pos, :integer
    add_column :marathons, :y_pos, :integer
  end
end
