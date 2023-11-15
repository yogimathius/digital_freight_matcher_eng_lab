require "test_helper"

class RoutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_order = {
      cargo: {
        packages: [1, 60, 'standard']
      },
      pick_up: {
        latitude: 33.754413815792205,
        longitude: -84.3875298776525
      },
      drop_off: {
        latitude: 34.87433824316913,
        longitude: -85.08447506395166
      }
    }

    @route = routes(:one)
    @route1 = routes(:route1)
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

  test "should raise error if no order provided" do
    assert_raises(ActionController::ParameterMissing) do
      get matching_routes_url, params: {}
    end
  end

  test "should raise error if order incomplete" do
    assert_raises(ActionController::ParameterMissing) do
      get matching_routes_url, params: { order: {} }
    end
  end

  test "should return invalid params message if order missing pick_up" do
    get matching_routes_url, params: {
      order: {
        cargo: {
          packages: [1, 60, 'standard']
        },
        drop_off: {
          latitude: 34.87433824316913,
          longitude: -85.08447506395166
        }
      }
    }

    assert_response :unprocessable_entity

    assert_equal 'Invalid order parameters', @response.body
  end

  test "should return invalid params message if order missing cargo" do
    get matching_routes_url, params: {
      order: {
        pick_up: {
          latitude: 33.754413815792205,
          longitude: -84.3875298776525
        },
        drop_off: {
          latitude: 34.87433824316913,
          longitude: -85.08447506395166
        }
      }
    }

    assert_response :unprocessable_entity

    assert_equal 'Invalid order parameters', @response.body
  end

  test "should return invalid params message if order missing dropoff" do
    get matching_routes_url, params: {
      order: {
        cargo: {
          packages: [1, 60, 'standard']
        },
        pick_up: {
          latitude: 33.754413815792205,
          longitude: -84.3875298776525
        }
      }
    }

    assert_response :unprocessable_entity

    assert_equal 'Invalid order parameters', @response.body
  end

  test "returns eligible routes if coords match waypoint" do
    get matching_routes_url params: { order: @mock_order }

    # ID 1 is Ringgold
    expected = Route.find(1)

    assert_response :ok

    assert_equal [expected].to_json, @response.body
  end
end
