class CreateFollowingTags < ActiveRecord::Migration
  def change
    create_table :following_tags do |t|
      t.references :user, null: false, index: true
      t.references :tag, null: false, index: true

      t.timestamps null: false
    end

    add_foreign_key :following_tags, :users, on_delete: :cascade
    add_index :following_tags, [:user_id, :tag_id], unique: true
  end
end
