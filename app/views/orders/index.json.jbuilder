json.array!(@orders) do |order|
  json.extract! order, :id, :purchase_count, :user_id, :merchant_id, :product_id
  json.url order_url(order, format: :json)
end
