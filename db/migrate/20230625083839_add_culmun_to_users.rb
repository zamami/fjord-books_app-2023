class AddCulmunToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :zip, :string
    add_column :users, :address, :string
    add_column :users, :profile, :text
  end
end
