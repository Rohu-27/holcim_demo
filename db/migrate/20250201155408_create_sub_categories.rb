class CreateSubCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :sub_categories do |t|
      t.string :name
      t.datetime :deleted_at
      t.references :category, null: false,foreign_key: true
      t.timestamps
    end
  end
end
