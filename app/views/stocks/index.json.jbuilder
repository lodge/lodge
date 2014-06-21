json.array!(@stocks) do |stock|
  json.extract! stock, :id, :user_id, :article_id
  json.url stock_url(stock, format: :json)
end
