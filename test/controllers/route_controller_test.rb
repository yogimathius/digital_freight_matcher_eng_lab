require "test_helper"

class RouteControllerTest < ActionDispatch::IntegrationTest
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

    @mock_route = routes(:route1)

    @route_controller = RouteController.new
  end

  test "returns empty array if no order" do

    result = @route_controller.get(order: {})
    

    assert_equal nil, result
  end

  # endwise extension, autofills most do-end blocks
  test "returns empty array if order incomplete" do
    incomplete = @mock_order.clone
    incomplete[:pick_up] = nil

    result = @route_controller.get(order: incomplete)

    assert_equal nil, result
  end

  test "returns eligible routes if coords match waypoint" do
    result = @route_controller.get(order: @mock_order)

    # ID 1 is Ringgold
    expected = Route.find(1)

    assert_equal [expected], result
  end
end
