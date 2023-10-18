require "test_helper"



class RouteControllerTest < ActionDispatch::IntegrationTest
  test "returns empty array if no order" do
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
    result = RouteController.new().get(order: {})
    

    assert result.empty?
  end
end
