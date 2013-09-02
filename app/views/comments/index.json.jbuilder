json.array!(@comments) do |comment|
  json.extract! comment, :product_id, :order_id, :comment, :date, :score
  json.url comment_url(comment, format: :json)
end
