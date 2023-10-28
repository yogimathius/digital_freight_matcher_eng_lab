class RouteController < ApplicationController
  include Math

  attr_accessor :order

  def initialize
    @mock_route = [
      {
      "latitude" => 33.754413815792205,
      "longitude" => -84.3875298776525
      },
      {
      "latitude" => 34.87433823445323,
      "longitude" => -85.084123334995166
      },
      {
      "latitude" => 34.87433823445323,
      "longitude" => -85.084123334995166
      },
      {
      "latitude" => 34.87433824316913,
      "longitude" => -85.08447506395166
      },
      {
      "latitude" => 33.754413815792205,
      "longitude" => -84.3875298776525 
      }
    ]
  end

  def get(order: {})
    return nil unless is_valid_order?(order)

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

    truck_capacity = CargoItem.new(9180, 1700)

    matching_pick_up_routes = select_fitting_cargo(matching_pick_up_routes, truck_capacity)


    {
      matching_origin_routes: matching_pick_up_routes,
      matching_drop_off_routes: matching_drop_off_routes
    }
  end

  def is_valid_order?(order)
    if order.empty?
      return false
    end
    if order[:pick_up].nil?
      return false
    end
    true
  end

  def get_routes_in_range(order_coords)
    Route.select do |route|
      route.in_range?(order_coords, route)
    end
  end
  
  def select_fitting_cargo(routes, truck_capacity)
    routes.filter do |route|
      route_cargo_fits_truck?(route, truck_capacity)
    end
  end

  def route_cargo_fits_truck?(route, truck_capacity)
    total_weight = 0
    total_volume = 0

    route.cargo_items.each do |cargo_item|
      total_weight += cargo_item.weight
      total_volume += cargo_item.volume
    end

    cargo_fits_weight = total_weight <= truck_capacity.max_weight
    cargo_fits_volume = total_volume <= truck_capacity.total_volume

    cargo_fits_weight && cargo_fits_volume
  end
end

