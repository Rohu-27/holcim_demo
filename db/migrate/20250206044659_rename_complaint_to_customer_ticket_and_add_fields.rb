class RenameComplaintToCustomerTicketAndAddFields < ActiveRecord::Migration[7.2]
  def change
    rename_table :complaints, :customer_tickets

    add_column :customer_tickets, :ticket_number, :string
    add_column :customer_tickets, :comment, :string
  end
end
