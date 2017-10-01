class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :user, null: false, index: true
      t.string :title, null: false, limit: 100
      t.text :body, null: false, default: nil

      t.timestamps null: false
    end

    add_foreign_key :articles, :users, on_delete: :cascade
  end
end
