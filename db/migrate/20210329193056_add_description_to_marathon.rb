class AddDescriptionToMarathon < ActiveRecord::Migration[6.0]
  def change
    add_column :marathons, :description, :text
  end
end
