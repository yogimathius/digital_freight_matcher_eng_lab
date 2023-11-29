require "test_helper"

class RoutesHelperTest < ActiveSupport::TestCase
  include RoutesHelper

  setup do
    @route1 = routes(:route1)
    @order1 = orders(:order1)
  end

  test "fits_in_shift? returns true when order fits within 10 hour shift duration of route1" do
    result = fits_in_shift?(@order1, @route1)
    assert result, true
  end

  test "fits_in_shift? returns false when order does not fit within 10 hour shift duration of route1" do
    9.times do
      @route1.orders << @order1
    end

    @still_fits = orders(:order1)
    # Should return true when adding 9 orders
    result = fits_in_shift?(@still_fits, @route1)
    assert result, true
    # add one more
    @route1.orders << @still_fits

    @doesnt_fit = orders(:order1)
    result = fits_in_shift?(@doesnt_fit, @route1)
    assert result, false
  end
end
