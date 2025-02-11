class AddParentIdToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :parent_id, :bigint
  end
end
