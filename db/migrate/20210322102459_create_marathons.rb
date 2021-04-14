class CreateMarathons < ActiveRecord::Migration[6.0]
  def change
    create_table :marathons do |t|
      t.string :name

      t.timestamps
    end
  end
end
