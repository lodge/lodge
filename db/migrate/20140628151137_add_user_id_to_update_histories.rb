class AddUserIdToUpdateHistories < ActiveRecord::Migration
  def up
    add_column :update_histories, :user_id, :integer, after: :article_id
    change_column :update_histories, :user_id, :integer, references: :user, null: false, index: true
  end
  def down
    remove_column :update_histories, :user_id
  end
end
