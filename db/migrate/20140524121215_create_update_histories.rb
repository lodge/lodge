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

      t.timestamps null: false
    end

    add_foreign_key :update_histories, :articles, on_delete: :cascade
  end
end
