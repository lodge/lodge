class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, null: false, index: true
      t.references :article, null: false, index: true
      t.text :body, null: false, default: nil

      t.timestamps
    end
  end
end
