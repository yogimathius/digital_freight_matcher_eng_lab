require "test_helper"
require 'csv'
require 'json'

class OrdersHelperTest < ActiveSupport::TestCase
  include OrdersHelper

  setup do
    @routes = Route.all
    @order = orders(:order1)
  end

  def self.run_large_test_suite?
    ENV['RUN_LARGE_TEST_SUITE'].to_i == 1
  end

  test "order_coords returns origin and destination if order is Order object" do
    pickup_coords, dropoff_coords = order_coords(@order)

    assert_instance_of Location, pickup_coords
    assert_instance_of Location, dropoff_coords
  end

  test "order_coords returns hash for pickup and dropoff if order is not Order object" do
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
    pickup_coords, dropoff_coords = order_coords(@mock_order)

    assert_not_instance_of Location, pickup_coords
    assert_not_instance_of Location, dropoff_coords
    assert_instance_of Hash, pickup_coords
    assert_instance_of Hash, dropoff_coords
  end

  if run_large_test_suite?

    ten_km_singles = CSV.open("test/fixtures/files/10_km_radius_loc.csv", headers: :first_row).map(&:to_h)
    ten_km_singles.each do |location|
      location_hash = location.transform_keys(&:to_sym)
      test "in_range? bulk validates pickup and dropoff points from ten km test data #{location_hash[:id]}" do
        is_valid = @routes.any? do |route|
          in_range?(location_hash, route, 1)
        end

        # is_valid = routes_in_range.include?(true) || routes_in_range.min < 1
        assert_equal location_hash[:valid].to_s, is_valid.to_s
      end
    end

    fifty_km_singles = CSV.open("test/fixtures/files/50_km_radius_loc.csv", headers: :first_row).map(&:to_h)

    fifty_km_singles.each do |location|
      location_hash = location.transform_keys(&:to_sym)
      test "in_range? bulk validates pickup and dropoff points from fifty km test data #{location_hash[:id]}" do
        is_valid = @routes.any? do |route|
          in_range?(location_hash, route, 1)
        end

        # is_valid = routes_in_range.include?(true) || routes_in_range.min < 1

        assert_equal location_hash[:valid].to_s, is_valid.to_s
      end
    end

    hundred_km_singles = CSV.open("test/fixtures/files/100_km_radius_loc.csv", headers: :first_row).map(&:to_h)

    hundred_km_singles.each do |location|
      location_hash = location.transform_keys(&:to_sym)
      test "in_range? bulk validates pickup and dropoff points from hundred km test data #{location_hash[:id]}" do
        is_valid = @routes.any? do |route|
          in_range?(location_hash, route, 1)
        end

        assert_equal location_hash[:valid].to_s, is_valid.to_s
      end
    end
  end
end
