class RemoveAlbumIdFromComplaints < ActiveRecord::Migration[7.2]
  def change
    remove_column :complaints, :album_id, :integer
  end
end
