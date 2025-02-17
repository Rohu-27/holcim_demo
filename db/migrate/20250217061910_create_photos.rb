class CreatePhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :photos do |t|
      t.text :image_data
      t.bigint :album_id, null: false

      t.timestamps
    end
    add_foreign_key :photos, :albums
  end
end
