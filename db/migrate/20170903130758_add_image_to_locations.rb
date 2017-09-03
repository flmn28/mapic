class AddImageToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :image, :string
  end
end
