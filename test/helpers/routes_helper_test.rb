require "test_helper"

class RoutesHelperTest < ActiveSupport::TestCase
  include RoutesHelper

  setup do
    @route1 = routes(:route1)
    @order1 = orders(:order1)
  end

  test "fits_in_shift? returns true when order fits within 10 hour shift duration of route1" do
    result = fits_in_shift?(@order1, @route1)
    assert_equal result, true
  end

  test "fits_in_shift? returns false when order does not fit within 10 hour shift duration of route1" do
    9.times do
      create_mock_order
    end

    @still_fits = orders(:order1)
    # Should return true when adding 9 orders
    result = fits_in_shift?(@still_fits, @route1)
    assert_equal result, true
    # add one more
    @route1.orders << @still_fits

    @doesnt_fit = orders(:order1)
    result = fits_in_shift?(@doesnt_fit, @route1)
    assert_equal result, false
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
      route: @route1
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
