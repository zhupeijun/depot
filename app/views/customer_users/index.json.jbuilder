json.array!(@customer_users) do |customer_user|
  json.extract! customer_user, :name, :password_digest, :email
  json.url customer_user_url(customer_user, format: :json)
end
