require "test_helper"
require 'csv'
require 'json'

class OrdersHelperTest < ActiveSupport::TestCase
  include OrdersHelper

  setup do
    @routes = Route.all
  end

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
