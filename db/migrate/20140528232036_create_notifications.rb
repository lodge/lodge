class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, null: false, index: true
      t.references :article
      t.string  :type, null: false   # for STI
      t.string  :state, null: false  # create, update, destroy

      t.timestamps
    end

    add_foreign_key :notifications, :users, on_delete: :cascade
    add_foreign_key :notifications, :articles, on_delete: :cascade
  end
end
