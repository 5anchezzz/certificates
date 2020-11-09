class AddAttachmentTemplateToCertificates < ActiveRecord::Migration[6.0]
  def up
    add_attachment :certificates, :template
  end

  def down
    remove_attachment :certificates, :template
  end
end
