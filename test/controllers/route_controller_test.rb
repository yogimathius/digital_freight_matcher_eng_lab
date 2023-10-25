require "test_helper"



class RouteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mock_order = {
      "cargo" => {
       "packages" => [1, 60, 'standard'] # CBM (vol.), weight (pounds), type
      },
      "pick_up" => {
        "latitude" => 33.754413815792205,
        "longitude" => -84.3875298776525
      },
      "drop_off" => {
        "latitude" => 34.87433824316913,
        "longitude" => -85.08447506395166
      }
    }

    @mock_route = [
      {
      "latitude" => 33.754413815792205,
      "longitude" => -84.3875298776525
      },
      {
      "latitude" => 34.87433823445323,
      "longitude" => -85.084123334995166
      },
      {
      "latitude" => 34.87433823445323,
      "longitude" => -85.084123334995166
      },
      {
      "latitude" => 34.87433824316913,
      "longitude" => -85.08447506395166
      },
      {
      "latitude" => 33.754413815792205,
      "longitude" => -84.3875298776525 
      }
    ]

    @route_controller = RouteController.new
  end

  test "returns empty array if no order" do

    result = @route_controller.get(order: {})
    

    assert_equal [], result
  end

  # endwise extension, autofills most do-end blocks
  test "returns empty array if order incomplete" do
    incomplete = @mock_order.clone
    incomplete["pick_up"] = nil

    result = @route_controller.get(order: incomplete)

    assert_equal [], result
  end

  test "returns eligible route if coords match waypoint" do
    result = @route_controller.get(order: @mock_order)

    assert_equal [@mock_route], result
  end

  test "get_triangular_height" do
    atlanta_to_resecca = 64.74
    ringgold_to_resecca = 25.52
    atlanta_to_ringgold = 90.24

    triangular_height = RouteController.new.get_triangular_height(
      atlanta_to_resecca,
      ringgold_to_resecca,
      atlanta_to_ringgold
    )

    assert_equal 0.8555837887170749, triangular_height
  end
end
