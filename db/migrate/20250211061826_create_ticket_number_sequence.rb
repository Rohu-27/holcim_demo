class CreateTicketNumberSequence < ActiveRecord::Migration[7.2]
  def up
    # Create the sequence in the database
    execute <<-SQL
      CREATE SEQUENCE ticket_number_seq START 1;
    SQL
  end
end
