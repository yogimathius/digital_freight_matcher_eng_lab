require "test_helper"

class OrderTest < ActiveSupport::TestCase
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

  test "build_order should create a client, package, locations, cargo and order with params" do
    client = Client.create!
    result = Order.new.build_order(@mock_order, @mock_route, client)

    expected = Order.last
    assert_equal expected, result
  end
end
