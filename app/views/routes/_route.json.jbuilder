json.extract! route, :id, :origin_id, :destination_id, :path, :anchor_point, :miles_with_cargo, :total_miles, :operational_truck_cost, :pallets, :cargo_cost, :empty_cargo_cost, :markup,
              :price_based_on_total_cost, :price_based_on_cargo_cost, :margin, :pickup_dropoff_qty, :time_hours, :contract_name, :created_at, :updated_at
json.url route_url(route, format: :json)
