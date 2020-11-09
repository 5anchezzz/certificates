class CreateTables < ActiveRecord::Migration[6.0]
  def change
    create_table :tables do |t|
      t.string :name
      t.string :state
      t.text :description
      t.text :logs

      t.timestamps
    end
  end
end
