# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140629055323) do

  create_table "articles", force: true do |t|
    t.integer  "user_id",                                       null: false
    t.string   "title",              limit: 100,                null: false
    t.text     "body",                                          null: false
    t.boolean  "is_public_editable",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",                 default: 0,    null: false
    t.integer  "lock_version",                   default: 0
  end

  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "article_id", null: false
    t.text     "body",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "following_tags", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "following_tags", ["tag_id"], name: "index_following_tags_on_tag_id", using: :btree
  add_index "following_tags", ["user_id", "tag_id"], name: "index_following_tags_on_user_id_and_tag_id", unique: true, using: :btree
  add_index "following_tags", ["user_id"], name: "index_following_tags_on_user_id", using: :btree

  create_table "notification_targets", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "notification_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_targets", ["notification_id"], name: "index_notification_targets_on_notification_id", using: :btree
  add_index "notification_targets", ["user_id"], name: "index_notification_targets_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "article_id"
    t.string   "type",       null: false
    t.string   "state",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["article_id"], name: "notifications_article_id_fk", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "stocks", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "article_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["article_id"], name: "index_stocks_on_article_id", using: :btree
  add_index "stocks", ["user_id", "article_id"], name: "index_stocks_on_user_id_and_article_id", unique: true, using: :btree
  add_index "stocks", ["user_id"], name: "index_stocks_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "update_histories", force: true do |t|
    t.integer  "article_id", null: false
    t.integer  "user_id",    null: false
    t.string   "new_title",  null: false
    t.string   "new_tags"
    t.text     "new_body",   null: false
    t.string   "old_title",  null: false
    t.string   "old_tags"
    t.text     "old_body",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "update_histories", ["article_id"], name: "index_update_histories_on_article_id", using: :btree
  add_index "update_histories", ["user_id"], name: "index_update_histories_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                               null: false
    t.string   "gravatar"
    t.string   "email",                              null: false
    t.string   "encrypted_password",                 null: false
    t.string   "comment"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0, null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "articles", "users", name: "articles_user_id_fk", dependent: :delete

  add_foreign_key "following_tags", "users", name: "following_tags_user_id_fk", dependent: :delete

  add_foreign_key "notification_targets", "notifications", name: "notification_targets_notification_id_fk", dependent: :delete
  add_foreign_key "notification_targets", "users", name: "notification_targets_user_id_fk", dependent: :delete

  add_foreign_key "notifications", "articles", name: "notifications_article_id_fk", dependent: :delete
  add_foreign_key "notifications", "users", name: "notifications_user_id_fk", dependent: :delete

  add_foreign_key "stocks", "articles", name: "stocks_article_id_fk", dependent: :delete
  add_foreign_key "stocks", "users", name: "stocks_user_id_fk", dependent: :delete

  add_foreign_key "update_histories", "articles", name: "update_histories_article_id_fk", dependent: :delete

end
