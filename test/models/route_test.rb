require "test_helper"

class RouteTest < ActiveSupport::TestCase
  include OrdersHelper

  setup do
    @mock_order = orders(:order1)

    @mock_route = routes(:route1)
  end

  test "route_profit" do
    route_profit = @mock_route.route_profit

    # route only has one order with one package, so these function executions will capture total extra earnings plus current cargo cost
    assert_equal(@mock_route.price_based_on_cargo_cost + profitability(@mock_route.orders.first, @mock_route), route_profit)
  end
end
