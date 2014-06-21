json.array!(@keywords) do |keyword|
  json.extract! keyword, :id, :name
  json.url keyword_url(keyword, format: :json)
end
