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

  test "find_matching_routes_for_order returns routes if order fits in shift" do
    matching_routes = Route.find_matching_routes_for_order(@mock_order)

    assert matching_routes.any?

    route1 = matching_routes.first

    9.times do
      create_mock_order
    end

    route1.save!

    matching_routes = Route.find_matching_routes_for_order(@mock_order)

    assert matching_routes.any?
  end

  test "find_matching_routes_for_order returns empty array if order doesn't fit in shift" do
    10.times do
      create_mock_order
    end

    matching_routes = Route.find_matching_routes_for_order(@mock_order)

    assert matching_routes.empty?
  end

  def self.run_large_test_suite?
    ENV['RUN_LARGE_TEST_SUITE'].to_i == 1
  end

  if run_large_test_suite?
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

  def create_mock_order
    truck1 = trucks(:truck1)
    ringgold = locations(:ringgold)
    atlanta = locations(:atlanta)
    client1 = clients(:client1)

    order1 = Order.create!(
      origin_id: ringgold.id,
      destination_id: atlanta.id,
      client: client1,
      route: @mock_route
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

    order1
  end
end
