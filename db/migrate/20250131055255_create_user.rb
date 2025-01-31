class CreateUser < ActiveRecord::Migration[7.2]
  def change
    create_table :users,id: :string do |t|
      t.string :email
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end