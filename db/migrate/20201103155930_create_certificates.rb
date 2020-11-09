class CreateCertificates < ActiveRecord::Migration[6.0]
  def change
    create_table :certificates do |t|
      t.string :name
      t.string :speaker
      t.text :description
      t.date :date
      t.string :language
      t.integer :xpos
      t.integer :ypos

      t.timestamps
    end
  end
end
