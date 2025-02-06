class AddTypeToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :type, :string
  end
end
