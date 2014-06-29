class AddUserIdToUpdateHistories < ActiveRecord::Migration
  def change
    change_table :update_histories do |t|
      t.references :user, null: false, index: true, after: :article_id
    end
  end
end
