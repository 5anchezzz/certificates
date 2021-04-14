class AddAttachmentLogoToMarathons < ActiveRecord::Migration[6.0]
  def self.up
    change_table :marathons do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :marathons, :logo
  end
end
