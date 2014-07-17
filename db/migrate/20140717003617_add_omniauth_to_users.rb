class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :token, :string

    add_index :users, [:uid, :provider], unique: true
  end
end
