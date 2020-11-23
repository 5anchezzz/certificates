class AddEngTranslationToCertificate < ActiveRecord::Migration[6.0]
  def change
    add_column :certificates, :speaker_eng, :string
    add_column :certificates, :description_eng, :text
  end
end
