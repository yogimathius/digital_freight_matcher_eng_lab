class Route < ApplicationRecord
  include Math
  extend OrdersHelper
  include CoordinateHelper
  include OrdersHelper

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_one :truck, dependent: :destroy
  has_many :orders, dependent: :destroy

  def self.find_matching_routes_for_order(order_params)
    pick_up_coords, drop_off_coords = order_coords(order_params)

    matching_pick_up_route = select do |route|
      in_range?(pick_up_coords, route, 1)
    end

    matching_drop_off_routes = select do |route|
      in_range?(drop_off_coords, route, 1)
    end

    matching_pick_up_route.filter do |route|
      matching_drop_off_routes.map(&:id).include?(route.id)
    end

    # Check truck package capacity (make sure order doesn’t overload truck)
    # matching_routes = matching_routes.filter do |route|

    # end
    # Check truck shift duration (route doesn’t exceed 10 hrs)
    # matching_routes = matching_routes.filter do |route|

    # end

    # matching_routes
  end

  def route_distance
    spherical_distance(
      origin,
      destination
    )
  end

  def route_profit
    order_profits = orders.map do |order|
      order.cargo.packages.map do
        profitability(order, self)
      end.sum
    end.sum

    price_based_on_cargo_cost + order_profits
  end
end
