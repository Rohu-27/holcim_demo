class AddUniqueIndexToNameInStatus < ActiveRecord::Migration[7.2]
  def change
    add_index :statuses, :name, unique: true  
  end
end
