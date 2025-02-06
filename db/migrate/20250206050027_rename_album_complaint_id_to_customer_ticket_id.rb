class RenameAlbumComplaintIdToCustomerTicketId < ActiveRecord::Migration[7.2]
  def change
    rename_column :albums, :complaint_id, :customer_ticket_id
  end
end
