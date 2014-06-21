class CreateUpdateHistories < ActiveRecord::Migration
  def change
    create_table :update_histories do |t|
      t.references :article, index: true, null: false
      t.string :new_title, null: false
      t.string :new_tags
      t.text :new_body, null: false
      t.string :old_title, null: false
      t.string :old_tags
      t.text :old_body, null: false
      t.foreign_key :articles, dependent: :delete

      t.timestamps
    end
  end
end
