class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.references :user, index: true, null: false
      t.references :article, index: true, null: false
      t.string :title, null: false
      t.string :tags
      t.text :body, null: false
      t.foreign_key :users, dependent: :delete
      t.foreign_key :articles, dependent: :delete

      t.timestamps
    end
  end
end
