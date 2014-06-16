json.array!(@users) do |user|
  json.extract! user, :id, :input, :from, :to, :output
  json.url user_url(user, format: :json)
end
