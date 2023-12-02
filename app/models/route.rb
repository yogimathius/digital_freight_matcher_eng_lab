require 'geocoder'

class Route < ApplicationRecord
  extend OrdersHelper
  extend RoutesHelper

  include Math
  include CoordinateHelper
  include OrdersHelper
  include RoutesHelper

  KM_MULTIPLIER = 1.60934

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_one :truck, dependent: :destroy
  has_many :orders, dependent: :destroy

  def self.routes_in_range(order_params, proximity)
    pick_up_coords, drop_off_coords = order_coords(order_params)

    matching_pick_up_route = Route.select do |route|
      in_range?(pick_up_coords, route, proximity)
    end

    matching_drop_off_routes = Route.select do |route|
      in_range?(drop_off_coords, route, proximity)
    end

    matching_pick_up_route.filter do |route|
      matching_drop_off_routes.map(&:id).include?(route.id)
    end
  end

  def self.find_matching_routes_for_order(order_params)
    matching_routes = routes_in_range(order_params, 1)

    # Check truck package capacity (make sure order doesn’t overload truck)
    # matching_routes = matching_routes.filter do |route|

    # end
    # Check truck shift duration (route doesn’t exceed 10 hrs)
    matching_routes.select do |route|
      route.fits_in_shift?(order_params)
    end
  end

  def route_distance
    Geocoder::Calculations.distance_between(
      [origin.latitude, origin.longitude],
      [destination.latitude, destination.longitude]
    ) * KM_MULTIPLIER
  end

  def route_profit
    order_profits = orders.map do |order|
      order.cargo.packages.map do
        profitability(order, self)
      end.sum
    end.sum

    price_based_on_cargo_cost + order_profits
  end

  def can_carry_medicine?
    orders.none? do |order|
      order.cargo.packages.any? do |package|
        package.package_type == 'food' || package.package_type == 'standard'
      end
    end
  end

  def order_deviation_time
    calculate_order_deviation_time(self)
  end

  def total_route_deviation_time
    orders.sum { calculate_order_deviation_time(self) }
  end

  def route_time
    total_route_deviation_time + time_hours
  end

  def current_route_time
    should_take_break? ? route_time + 0.5 : route_time
  end

  def fits_in_shift?(_order)
    current_route_time + order_deviation_time < MAX_SHIFT_DURATION
  end

  def should_take_break?
    route_time > 4
  end
end
