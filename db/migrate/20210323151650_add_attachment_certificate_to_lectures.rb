class AddAttachmentCertificateToLectures < ActiveRecord::Migration[6.0]
  def self.up
    change_table :lectures do |t|
      t.attachment :certificate
    end
  end

  def self.down
    remove_attachment :lectures, :certificate
  end
end
