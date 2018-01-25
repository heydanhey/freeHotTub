class CreateFhts < ActiveRecord::Migration[5.1]
  def change
    create_table :fhts do |t|
      t.string :link
      t.string :image_link
      t.string :title

      t.timestamps
    end
  end
end
