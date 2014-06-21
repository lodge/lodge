json.array!(@update_histories) do |update_history|
  json.extract! update_history, :id, :article_id, :new_title, :new_tags, :new_body, :old_title, :old_tags, :old_body
  json.url update_history_url(update_history, format: :json)
end
