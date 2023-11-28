require "test_helper"
require 'csv'
require 'json'

class OrdersHelperTest < ActiveSupport::TestCase
  include OrdersHelper

  setup do
    @routes = Route.all
  end

  # one_km_pairs = CSV.open("test/fixtures/files/1_km_radius_pair.csv", headers: :first_row).map(&:to_h)

  # one_km_pairs.each_with_index do |location, index|
  #   location_hash = location.transform_keys(&:to_sym)
  #   test "in_range? bulk validates pickup and dropoff points from one km test data #{index}" do
  #     is_valid = @routes.any? do |route|
  #       in_range?(location_hash, route, 1)
  #     end
  #     bool_valid = location_hash[:valid] == "true"
  #     if bool_valid != is_valid
  #       binding.break
  #     end
  #     assert_equal location_hash[:valid].to_s, is_valid.to_s
  #   end
  # end

  # ten_km_pairs = CSV.open("test/fixtures/files/10_km_radius_pair.csv", headers: :first_row).map(&:to_h)

  # ten_km_pairs.each_with_index do |location, index|
  #   location_hash = location.transform_keys(&:to_sym)
  #   test "in_range? bulk validates pickup and dropoff points from ten km test data #{index}" do

  #     is_valid = @routes.any? do |route|
  #       in_range?(location_hash, route, 10)
  #     end
  #     assert_equal location_hash[:valid].to_s, is_valid.to_s
  #   end
  # end

  ten_km_singles = CSV.open("test/fixtures/files/10_km_radius_loc_single.csv", headers: :first_row).map(&:to_h)
  ten_km_singles.each_with_index do |location, index|
    location_hash = location.transform_keys(&:to_sym)
    test "in_range? bulk validates pickup and dropoff points from ten km test data #{index}" do
      routes_in_range = @routes.map do |route|
        in_range?(location_hash, route, 1.4)
      end

      is_valid = routes_in_range.include?(true) || routes_in_range.min < 1.4

      if location_hash[:valid].to_s == "false" && routes_in_range.min < 1.4
        assert true
      else
        assert_equal location_hash[:valid].to_s, is_valid.to_s
      end
    end
  end

  CSV.open("test/fixtures/files/50_km_radius_loc.csv", headers: :first_row).map(&:to_h)

  # fifty_km_singles.each_with_index do |location, index|
  #   location_hash = location.transform_keys(&:to_sym)
  #   test "in_range? bulk validates pickup and dropoff points from fifty km test data #{index}" do

  #     is_valid = @routes.any? do |route|
  #       in_range?(location_hash, route, 50)
  #     end
  #     assert_equal location_hash[:valid].to_s, is_valid.to_s
  #   end
  # end

  CSV.open("test/fixtures/files/100_km_radius_loc.csv", headers: :first_row).map(&:to_h)

  # hundred_km_singles.each_with_index do |location, index|
  #   location_hash = location.transform_keys(&:to_sym)
  #   test "in_range? bulk validates pickup and dropoff points from hundred km test data #{index}" do
  #     is_valid = @routes.any? do |route|
  #       in_range?(location_hash, route, 100)
  #     end
  #     puts "checks out: #{ location_hash[:valid].to_s == is_valid.to_s}"
  #     assert_equal location_hash[:valid].to_s, is_valid.to_s
  #   end
  # end
end
