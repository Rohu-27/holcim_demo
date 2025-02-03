class CreateAlbumsAndPhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :albums do |t|
      t.string     :title
      t.timestamps
    end

    create_table :photos do |t|
      t.references :album, foreign_key: true
      t.text       :image_data
      t.timestamps
    end
  end
end
