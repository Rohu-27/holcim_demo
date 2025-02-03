class CreateComplaints < ActiveRecord::Migration[7.2]
  def change
    create_table :complaints do |t|
      t.string :category
      t.string :sub_category
      t.string :description
      t.datetime :deleted_at

      t.timestamps

      t.references :user, foreign_key: true
      t.references :album, foreign_key: true
    end
  end
end
