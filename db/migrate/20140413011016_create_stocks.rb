class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references :user, null: false, index: true
      t.references :article, null: false, index: true
      t.foreign_key :users, dependent: :delete
      t.foreign_key :articles, dependent: :delete

      t.timestamps
    end

    add_index :stocks, [:user_id, :article_id], unique: true
  end
end
