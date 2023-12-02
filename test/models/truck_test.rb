# frozen_string_literal: true

require "test_helper"

class TruckTest < ActiveSupport::TestCase
  setup do
    @mock_order = orders(:order1)

    @truck = Truck.first
  end

  test "capacity? returns true when cargo can fit in truck" do
    result = @truck.capacity?(@mock_order.cargo)
    assert_equal true, result
  end

  test "capacity? returns false when cargo volume exceeds truck's capacity" do
    result = @truck.capacity?(@mock_order.cargo)
    assert_equal true, result

    @mock_order.cargo.packages.each do |package|
      package.update(volume: 15_000)
    end

    result = @truck.capacity?(@mock_order.cargo)
    assert_equal false, result
  end
end
