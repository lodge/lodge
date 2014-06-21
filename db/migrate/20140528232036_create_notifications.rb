class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, null: false, index: true
      t.references :article
      t.string  :type, null: false   # for STI
      t.string  :state, null: false  # create, update, destroy
      t.foreign_key :users, dependent: :delete
      t.foreign_key :articles, dependent: :delete

      t.timestamps
    end
  end
end
