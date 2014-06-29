class AddIsPublicEditableColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_public_editable, :boolean, default: true, after: :body
  end
end
