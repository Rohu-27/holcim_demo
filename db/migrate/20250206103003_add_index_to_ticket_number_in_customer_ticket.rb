class AddIndexToTicketNumberInCustomerTicket < ActiveRecord::Migration[7.2]
  def change
    add_index :customer_tickets ,:ticket_number, unique: true
  end
end
