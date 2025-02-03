class AddComplaintIdToAlbums < ActiveRecord::Migration[7.2]
  def change
    add_reference :albums, :complaint, foreign_key: true
  end
end
