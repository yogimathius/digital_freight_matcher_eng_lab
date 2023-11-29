require "test_helper"
require 'csv'
require 'json'

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

  one_km = CSV.open("test/fixtures/files/1_km_radius_pair.csv", headers: :first_row).map(&:to_h)
  order_args = one_km.each_slice(2).to_a
  order_args.each do |pickup, dropoff|
    pickup_hash = pickup.transform_keys(&:to_sym)
    dropoff_hash = dropoff.transform_keys(&:to_sym)

    expected = pickup_hash[:valid]
    order_params = {
      pick_up: pickup_hash,
      drop_off: dropoff_hash
    }

    test "in_range? bulk validates pickup and dropoff points from 1 km test data #{pickup_hash[:id]}" do
      is_valid = Route.routes_in_range(order_params, 1).any?

      assert_equal expected, is_valid.to_s
    end
  end

  ten_km = CSV.open("test/fixtures/files/10_km_radius_pair.csv", headers: :first_row).map(&:to_h)
  order_args = ten_km.each_slice(2).to_a
  order_args.each do |pickup, dropoff|
    pickup_hash = pickup.transform_keys(&:to_sym)
    dropoff_hash = dropoff.transform_keys(&:to_sym)

    expected = pickup_hash[:valid]
    order_params = {
      pick_up: pickup_hash,
      drop_off: dropoff_hash
    }

    test "in_range? bulk validates pickup and dropoff points from ten km test data #{pickup_hash[:id]}" do
      routes = Route.routes_in_range(order_params, 1)

      is_valid = routes.any?
      # binding.break if is_valid.to_s != expected

      assert_equal expected, is_valid.to_s
    end
  end
end
