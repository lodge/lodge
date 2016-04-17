class AddIsPublicEditableColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_public_editable, :boolean, after: :body, default: true
  end
end
