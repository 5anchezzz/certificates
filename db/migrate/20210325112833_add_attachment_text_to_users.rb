class AddAttachmentTextToUsers < ActiveRecord::Migration[6.0]
  def self.up
    change_table :users do |t|
      t.attachment :text
    end
  end

  def self.down
    remove_attachment :users, :text
  end
end
