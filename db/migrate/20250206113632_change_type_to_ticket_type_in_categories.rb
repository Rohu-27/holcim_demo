class ChangeTypeToTicketTypeInCategories < ActiveRecord::Migration[7.2]
  def change
    rename_column :categories, :type, :ticket_type
  end
end
