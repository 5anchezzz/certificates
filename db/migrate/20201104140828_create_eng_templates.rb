class CreateEngTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :eng_templates do |t|
      t.references :certificate, null: false, foreign_key: true
      t.integer :xpos
      t.integer :ypos
      t.string :font_color
      t.integer :font_size

      t.timestamps
    end
  end
end
