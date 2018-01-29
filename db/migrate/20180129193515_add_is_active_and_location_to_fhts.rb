class AddIsActiveAndLocationToFhts < ActiveRecord::Migration[5.1]
  def change
    add_column :fhts, :is_active, :boolean, default: true
    add_column :fhts, :location, :string
  end
end
