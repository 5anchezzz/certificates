class AddAttachmentPdfFileToEngTemplates < ActiveRecord::Migration[6.0]
  def self.up
    change_table :eng_templates do |t|
      t.attachment :pdf_file
    end
  end

  def self.down
    remove_attachment :eng_templates, :pdf_file
  end
end
