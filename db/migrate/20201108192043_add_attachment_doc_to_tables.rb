class AddAttachmentDocToTables < ActiveRecord::Migration[6.0]
  def self.up
    change_table :tables do |t|
      t.attachment :doc
    end
  end

  def self.down
    remove_attachment :tables, :doc
  end
end
