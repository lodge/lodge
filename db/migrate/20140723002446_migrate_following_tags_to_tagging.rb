class MigrateFollowingTagsToTagging < ActiveRecord::Migration
  def up
    sql = 'SELECT tag_id, user_id, created_at FROM following_tags'
    for tag in execute(sql)
      execute("INSERT INTO taggings (tag_id, taggable_id, taggable_type, context, created_at) VALUES(#{tag['tag_id']}, #{tag['user_id']}, 'User', 'following_tags', '#{tag['created_at']}')")
    end
    execute("DELETE FROM following_tags")
  end
  def down
    sql = "SELECT tag_id, taggable_id, created_at FROM taggings WHERE  taggable_type = 'User' AND context = 'following_tags'"
    for tagging in execute(sql)
      execute("INSERT INTO following_tags (user_id, tag_id, created_at) VALUES(#{tagging['taggable_id']}, #{tagging['tag_id']}, '#{tagging['created_at']}')")
    end
    execute("DELETE FROM taggings WHERE taggable_type = 'User' AND context = 'following_tags'")
  end
end
