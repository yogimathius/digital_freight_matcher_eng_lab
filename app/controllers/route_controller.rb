class RouteController < ApplicationController
  include Math

  attr_accessor :order

  def get(order: {})
    return nil unless valid_order?(order)

    pickup_coords = {
      latitude: order[:pick_up][:latitude],
      longitude: order[:pick_up][:longitude]
    }

    dropoff_coords = {
      latitude: order[:drop_off][:latitude],
      longitude: order[:drop_off][:longitude]
    }

    # Find matching routes for proximity (within 1 km)
    matching_pick_up_routes = get_routes_in_range(pickup_coords)

    matching_drop_off_routes = get_routes_in_range(dropoff_coords)

    # Check truck package capacity (make sure order doesn’t overload truck)
    # matching_routes = matching_routes.filter do |route|

    # end
    # Check truck shift duration (route doesn’t exceed 10 hrs)
    # matching_routes = matching_routes.filter do |route|

    # end

    routes_found = matching_pick_up_routes.present? && matching_drop_off_routes.present?

    # What should we really return? I think a message would be nice for the merchant at this point
    return nil unless routes_found

    matching_pick_up_routes.filter do |route|
      matching_drop_off_routes.map(&:id).include?(route.id)
    end
  end

  def valid_order?(order)
    return false if order.empty?
    return false if order[:pick_up].nil?

    true
  end

  def get_routes_in_range(order_coords)
    Route.select do |route|
      route.in_range?(order_coords)
    end
  end
end
