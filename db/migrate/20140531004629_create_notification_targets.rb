class CreateNotificationTargets < ActiveRecord::Migration
  def change
    create_table :notification_targets do |t|
      t.references :user, null: false, index: true
      t.references :notification, null: false, index: true

      t.timestamps null: false
    end

    add_foreign_key :notification_targets, :users, on_delete: :cascade
    add_foreign_key :notification_targets, :notifications, on_delete: :cascade
  end
end
