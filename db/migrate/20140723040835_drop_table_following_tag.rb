class DropTableFollowingTag < ActiveRecord::Migration
  def up
    remove_foreign_key :following_tags, :users
    drop_table :following_tags
  end

  def down
    create_table :following_tags do |t|
      t.references :user, null: false, index: true
      t.references :tag, null: false, index: true

      t.timestamps
    end

    add_foreign_key :following_tags, :users, on_delete: :cascade
    add_index :following_tags, [:user_id, :tag_id], unique: true
  end
end
