require "test_helper"

class RoutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @route = routes(:one)
  end

  test "should get index" do
    get routes_url
    assert_response :success
  end

  test "should get new" do
    get new_route_url
    assert_response :success
  end

  test "should create route" do
    assert_difference("Route.count") do
      post routes_url,
           params: { route: {
             anchor_point: @route.anchor_point,
             cargo_cost: @route.cargo_cost,
             contract_name: @route.contract_name,
             destination_id: @route.destination_id,
             empty_cargo_cost: @route.empty_cargo_cost,
             margin: @route.margin,
             markup: @route.markup,
             miles_with_cargo: @route.miles_with_cargo,
             operational_truck_cost: @route.operational_truck_cost,
             origin_id: @route.origin_id,
             pallets: @route.pallets,
             path: @route.path,
             pickup_dropoff_qty: @route.pickup_dropoff_qty,
             price_based_on_cargo_cost: @route.price_based_on_cargo_cost,
             price_based_on_total_cost: @route.price_based_on_total_cost,
             time_hours: @route.time_hours,
             total_miles: @route.total_miles
           } }
    end

    assert_redirected_to route_url(Route.last)
  end

  test "should show route" do
    get route_url(@route)
    assert_response :success
  end

  test "should get edit" do
    get edit_route_url(@route)
    assert_response :success
  end

  test "should update route" do
    patch route_url(@route),
          params: { route: {
            anchor_point: @route.anchor_point,
            cargo_cost: @route.cargo_cost,
            contract_name: @route.contract_name,
            destination_id: @route.destination_id,
            empty_cargo_cost: @route.empty_cargo_cost,
            margin: @route.margin,
            markup: @route.markup,
            miles_with_cargo: @route.miles_with_cargo,
            operational_truck_cost: @route.operational_truck_cost,
            origin_id: @route.origin_id,
            pallets: @route.pallets,
            path: @route.path,
            pickup_dropoff_qty: @route.pickup_dropoff_qty,
            price_based_on_cargo_cost: @route.price_based_on_cargo_cost,
            price_based_on_total_cost: @route.price_based_on_total_cost,
            time_hours: @route.time_hours,
            total_miles: @route.total_miles
          } }
    assert_redirected_to route_url(@route)
  end

  test "should destroy route" do
    assert_difference("Route.count", -1) do
      delete route_url(@route)
    end

    assert_redirected_to routes_url
  end
end
