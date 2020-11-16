class AddPdfResolutionToTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :rus_templates, :pdf_height, :integer
    add_column :rus_templates, :pdf_width, :integer
    add_column :eng_templates, :pdf_height, :integer
    add_column :eng_templates, :pdf_width, :integer
  end
end
