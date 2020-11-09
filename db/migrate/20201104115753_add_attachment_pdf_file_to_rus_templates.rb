class AddAttachmentPdfFileToRusTemplates < ActiveRecord::Migration[6.0]
  def self.up
    change_table :rus_templates do |t|
      t.attachment :pdf_file
    end
  end

  def self.down
    remove_attachment :rus_templates, :pdf_file
  end
end
