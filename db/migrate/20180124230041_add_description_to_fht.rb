class AddDescriptionToFht < ActiveRecord::Migration[5.1]
  def change
    add_column :fhts, :description, :text
  end
end
