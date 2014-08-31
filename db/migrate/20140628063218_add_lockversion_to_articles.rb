class AddLockversionToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :lock_version, :integer, default: 0
  end
end
