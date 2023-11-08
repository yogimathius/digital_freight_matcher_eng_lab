# frozen_string_literal: true

require "test_helper"

class TruckTest < ActiveSupport::TestCase
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

    @truck = Truck.all.first
  end

  test "has_capacity? returns true when cargo can fit in truck" do
    cargo = {
      max_weight: 9180,       
      total_volume: 1700,     
      pallet_per_truck: 26.6, 
  }
    result = @truck.has_capacity?(@mock_order[:cargo])
    assert_equal true, result
  end

  test "has_capacity? returns false when cargo exceeds truck's capacity" do
    cargo = {
      max_weight: 10000,     
      total_volume: 2000,   
      pallet_per_truck: 30, 
    }

    result = @truck.has_capacity?(@mock_order[:cargo])
    assert_equal false, result
  end
end
