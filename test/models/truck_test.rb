# frozen_string_literal: true

require "test_helper"

class TruckTest < ActiveSupport::TestCase
  setup do
    @mock_order = orders(:order1)

    @truck = Truck.all.first
  end

  test "has_capacity? returns true when cargo can fit in truck" do
    cargo = {
      max_weight: 9180,
      total_volume: 1700,
      pallet_per_truck: 26.6,
  }
    result = @truck.has_capacity?(@mock_order.cargo)
    assert_equal true, result
  end

  test "has_capacity? returns false when cargo volume exceeds truck's capacity" do
    cargo = {
      max_weight: 10000,
      total_volume: 2000,
      pallet_per_truck: 30,
    }

    result = @truck.has_capacity?(@mock_order.cargo)
    assert_equal true, result

    @mock_order.cargo.packages.each do |package|
      package.update(volume: 15000)
    end

    result = @truck.has_capacity?(@mock_order.cargo)
    assert_equal false, result
  end
end
