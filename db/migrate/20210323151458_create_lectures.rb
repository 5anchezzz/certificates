class CreateLectures < ActiveRecord::Migration[6.0]
  def change
    create_table :lectures do |t|
      t.references :marathon, null: false, foreign_key: true
      t.string :name
      t.string :speaker
      t.text :description
      t.date :date

      t.timestamps
    end
  end
end
