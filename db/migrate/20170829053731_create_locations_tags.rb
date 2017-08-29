class CreateLocationsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :locations_tags do |t|
      t.integer :location_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
