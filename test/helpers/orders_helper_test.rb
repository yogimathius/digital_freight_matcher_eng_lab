require "test_helper"
require 'csv'
require 'json'

class OrdersHelperTest < ActiveSupport::TestCase
  include OrdersHelper

  setup do
    @routes = Route.all
  end

  test "in_range? bulk validates pickup and dropoff points from one km test data" do
    one_km_data = CSV.open("test/1_km_radius_pair.csv", headers: :first_row).map(&:to_h)

    one_km_data.each do |location|
      location_hash = location.transform_keys(&:to_sym)

      is_valid = @routes.any? do |route|
        in_range?(location_hash, route, 1)
      end
      assert location_hash[:valid], is_valid
    end
  end

  test "in_range? bulk validates pickup and dropoff points from ten km test data" do
    ten_km_data = CSV.open("test/10_km_radius_pair.csv", headers: :first_row).map(&:to_h)

    ten_km_data.each do |location|
      location_hash = location.transform_keys(&:to_sym)

      is_valid = @routes.any? do |route|
        in_range?(location_hash, route, 10)
      end
      assert location_hash[:valid], is_valid
    end
  end
end
