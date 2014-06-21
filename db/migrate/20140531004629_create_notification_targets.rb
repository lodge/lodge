class CreateNotificationTargets < ActiveRecord::Migration
  def change
    create_table :notification_targets do |t|
      t.references :user, null: false, index: true
      t.references :notification, null: false, index: true
      t.foreign_key :users, dependent: :delete
      t.foreign_key :notifications, dependent: :delete

      t.timestamps
    end
  end
end
