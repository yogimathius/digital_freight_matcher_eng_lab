require "test_helper"

class RouteTest < ActiveSupport::TestCase
  setup do
    atlanta = Location.create!(
      latitude: 33.7488,
      longitude: 84.3877
    )

    ringgold = Location.create!(
      latitude: 34.9249,
      longitude: 85.1098
    )

    @ringgold_route = Route.create!(
      origin_id: atlanta.id,
      destination_id: ringgold.id,
      anchor_point: "Ringgold",
      miles_with_cargo: 101.0,
      total_miles: 202.0,
      operational_truck_cost: 342.16,
      pallets: 20,
      cargo_cost: 257.62404,
      empty_cargo_cost: 84.53,
      markup: 0.5,
      price_based_on_total_cost: 513.24,
      price_based_on_cargo_cost: 386.4360543,
      margin: 12.94,
      pickup_dropoff_qty: 2,
      time_hours: 4.0,
      contract_name: "Too-Big-To-Fail"
    )
  end

  test "waypoints" do
    waypoints = @ringgold_route.get_waypoints(10)
    binding.break
  end
end
