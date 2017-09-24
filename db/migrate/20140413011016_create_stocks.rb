class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references :user, null: false, index: true
      t.references :article, null: false, index: true

      t.timestamps
    end

    add_foreign_key :stocks, :users, on_delete: :cascade
    add_foreign_key :stocks, :articles, on_delete: :cascade
    add_index :stocks, [:user_id, :article_id], unique: true
  end
end
