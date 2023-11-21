json.extract! order, :id, :origin_id, :destination_id, :client_id, :route_id, :created_at, :updated_at
json.url order_url(order, format: :json)
