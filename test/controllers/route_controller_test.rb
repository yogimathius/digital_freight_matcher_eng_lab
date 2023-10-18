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
end
