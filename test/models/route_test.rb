require "test_helper"

class RouteTest < ActiveSupport::TestCase
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
  end

  test "profitability" do
    profitability = @mock_route.profitability(@mock_order)

    # hacky test assertion but at least will catch changes in the codebase that affect this function
    assert_equal("6.44", format('%.2f', profitability))
  end

  test "route_profit" do
    route_profit = @mock_route.route_profit

    
  end
end
