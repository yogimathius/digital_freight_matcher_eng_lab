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

    8.times do
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

  test "can_carry_medicine? returns true when no food or standard packages on route" do
    # savannah route has no orders, so should return true
    @savannah_route = routes("route3")

    result = @savannah_route.can_carry_medicine?

    assert_equal result, true
  end

  test "can_carry_medicine? returns false when food or standard packages on route" do
    # ringgold route has order with standard package, so should return false
    @ringgold_route = routes("route1")

    result = @ringgold_route.can_carry_medicine?

    assert_equal result, false
  end

  test "fits_in_shift? returns true when order fits within 10 hour shift duration of route1" do
    result = @mock_route.fits_in_shift?(@order1)
    assert_equal result, true
  end

  test "fits_in_shift? returns false when order does not fit within 10 hour shift duration of route1" do
    8.times do
      create_mock_order
    end

    @still_fits = orders(:order1)
    # Should return true when adding 9 orders
    result = @mock_route.fits_in_shift?(@still_fits)
    assert_equal result, true
    # add one more
    @mock_route.orders << @still_fits

    @doesnt_fit = orders(:order1)
    result = @mock_route.fits_in_shift?(@doesnt_fit)
    assert_equal result, false
  end

  test "should_take_break? returns true if shift duration > 4 hours" do
    short_route = routes(:route2)
    assert_equal false, short_route.should_take_break?

    create_mock_order(build_route_two: true)

    assert_equal true, short_route.should_take_break?
  end

  test "find_matching_routes_for_order with large weight order returns routes if truck has capacity" do
    @large_weight_order = create_mock_order(package_weight: 9130)
    matching_routes = Route.find_matching_routes_for_order(@large_weight_order)

    assert matching_routes.any?
  end

  test "find_matching_routes_for_order returns empty array if package size exceeds capacity" do
    @too_large_weight_order = create_mock_order(package_weight: 9131)
    matching_routes = Route.find_matching_routes_for_order(@too_large_weight_order)

    assert matching_routes.none?
  end

  def self.run_large_test_suite?
    ENV['RUN_LARGE_TEST_SUITE'].to_i == 1
  end

  def self.parse_json(json_string)
    JSON.parse(json_string.gsub(/(\w+):/, '"\1":'))
  end

  def self.parse_json_array(json_string)
    JSON.parse(json_string.gsub(/\w+/, '"\0"'))
  end

  def self.draft_order_object(csv_order)
    order_object = {
      cargo_attributes: {
        packages_attributes: []
      },
      origin_attributes: {},
      destination_attributes: {}
    }

    unpack_csv_order(order_object, csv_order)

    Order.new(order_object)
  end

  def self.unpack_csv_order(order_obj, csv_order)
    unpack_cargo(order_obj, csv_order["cargo"])
    unpack_location(order_obj, :origin_attributes, csv_order["pick_up"])
    unpack_location(order_obj, :destination_attributes, csv_order["drop_off"])
  end

  def self.unpack_cargo(order_obj, cargo_string)
    packages = parse_json_array(cargo_string)
    order_obj[:cargo_attributes][:packages_attributes] = [packages_to_hash(packages)]
  end

  def self.unpack_location(order_obj, key, location_string)
    order_obj[key] = parse_json(location_string)
    order_obj[key][:latitude] = order_obj[key]["latitude"].to_s
    order_obj[key][:longitude] = order_obj[key]["longitude"].to_s
    order_obj[key].delete("latitude")
    order_obj[key].delete("longitude")
  end

  def self.packages_to_hash(packages)
    [:volume, :weight, :package_type].zip(packages.map(&:to_s)).to_h
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

        assert_equal expected, is_valid.to_s
      end
    end

    full_orders = CSV.open("test/fixtures/files/full_orders.csv", headers: :first_row).map(&:to_h)
    full_orders.each do |full_csv_order|
      expected = parse_json(full_csv_order["valid"]).to_s
      id = parse_json(full_csv_order["id"])
      order_arg = draft_order_object(full_csv_order)

      test "in_range? bulk validates pickup and dropoff points for full orders #{id}" do
        routes = Route.routes_in_range(order_arg, 1)

        order_has_meds = order_arg.cargo.packages.first.package_type == 'medicine'
        is_valid = order_has_meds ? routes.any?(&:can_carry_medicine?) : routes.any?

        assert_equal expected, is_valid.to_s
      end
    end

    bonus_medicine = CSV.open("test/fixtures/files/full_orders_bonus.csv", headers: :first_row).map(&:to_h)
    bonus_medicine.each do |csv_order|
      expected = parse_json(csv_order["valid"]).to_s
      id = parse_json(csv_order["id"])
      order_arg = draft_order_object(csv_order)

      test "in_range? bulk validates pickup and dropoff points for medicine packages #{id}" do
        routes = Route.routes_in_range(order_arg, 1)

        order_has_meds = order_arg.cargo.packages.first.package_type == 'medicine'
        is_valid = order_has_meds ? routes.any?(&:can_carry_medicine?) : routes.any?

        assert_equal expected, is_valid.to_s
      end
    end
  end

  def create_mock_order(build_route_two: false, package_weight: 50, package_volume: 10)
    route = build_route_two ? routes(:route2) : routes(:route1)

    truck1 = trucks(:truck1)
    ringgold = locations(:ringgold)
    atlanta = locations(:atlanta)
    client1 = clients(:client1)

    order1 = Order.create!(
      origin_id: ringgold.id,
      destination_id: atlanta.id,
      client: client1,
      route: route
    )

    cargo1 = Cargo.create!(
      order: order1,
      truck: truck1
    )

    Package.create!(
      volume: 10,
      weight: package_weight,
      package_type: "standard",
      cargo: cargo1
    )
    route.orders << order1
    order1
  end
end
