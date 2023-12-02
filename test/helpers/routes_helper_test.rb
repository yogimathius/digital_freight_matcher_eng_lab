require "test_helper"

class RoutesHelperTest < ActiveSupport::TestCase
  include RoutesHelper

  setup do
    @route1 = routes(:route1)
    @order1 = orders(:order1)
  end

  test "schedule_on_return? returns true when pickup is closer to destination than dropoff" do
    # coords of this mock order will match atlanta to albany route
    @on_return_order = create_mock_order(reverse_locations: true)
    @albany_route = routes(:route4)

    result = schedule_on_return?(@on_return_order, @albany_route)

    assert_equal result, true
  end

  def create_mock_order(reverse_locations: false)
    truck1 = trucks(:truck1)
    pickup = reverse_locations ? locations(:medicine_pickup) : locations(:ringgold)
    dropoff = reverse_locations ? locations(:medicine_dropoff) : locations(:atlanta)
    client1 = clients(:client1)

    order1 = Order.create!(
      origin_id: pickup.id,
      destination_id: dropoff.id,
      client: client1,
      route: @route1
    )

    cargo1 = Cargo.create!(
      order: order1,
      truck: truck1
    )

    Package.create!(
      volume: 10,
      weight: 50,
      package_type: "Package Type X",
      cargo: cargo1
    )

    @route1.orders << order1
    order1
  end
end
