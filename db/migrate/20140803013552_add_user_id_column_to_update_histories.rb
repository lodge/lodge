class AddUserIdColumnToUpdateHistories < ActiveRecord::Migration
  def self.up
    add_column :update_histories, :user_id, :integer, after: :id
    update_histories = UpdateHistory.all.includes(article: :user)
    update_histories.each do |history|
      history.user_id = history.article.user.id
      history.save!
    end
    change_column :update_histories, :user_id, :integer, null: false
  end

  def self.down
    remove_column :update_histories, :user_id
  end
end
