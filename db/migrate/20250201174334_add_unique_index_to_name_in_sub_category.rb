class AddUniqueIndexToNameInSubCategory < ActiveRecord::Migration[7.2]
  def change
    add_index :sub_categories, :name, unique: true
  end
end
