class AddLockversionToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :lock_version, :integer, default: 0
    add_column :articles, :is_private, :boolean, default: false, after: :body
  end
end
