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
  
  # How to store array of profitable routes?
  def get(order: {})
    if is_valid_order?(order)
      routes = Route.all
      order_coords = {
        latitude: order["latitude"],
        longitude: order["longitude"]
      }
      matching_routes = filter_routes(order_coords, routes)

      if matching_routes.present?
        return [matching_routes]
      end
      []
    end
    []
  end

  def is_valid_order?(order)
    if order.empty? 
      return false
    end
    if order["pick_up"].nil?
      return false
    end
    true
  end

  def spherical_distance(start_coords, end_coords)
    radius = 6372.8 # rough radius of the Earth, in kilometers
    lat1, long1 = deg2rad *start_coords
    lat2, long2 = deg2rad *end_coords
    2 * radius * asin(sqrt((sin((lat2-lat1)/2)**2) + (cos(lat1) * cos(lat2) * (sin((long2 - long1)/2)**2))))
  end

  def deg2rad(lat, long)
    [(lat[1] * Math::PI / 180), (long[1] * Math::PI / 180)]
  end

  # Using Heron's formula: 
  def get_triangular_height(
    distance_from_origin,
    distance_from_destination,
    route_distance
  )
    root1 = Math.sqrt(distance_from_destination + route_distance + distance_from_origin)
    root2 = Math.sqrt(-distance_from_destination + route_distance + distance_from_origin)
    root3 = Math.sqrt(distance_from_destination - route_distance + distance_from_origin)
    root4 = Math.sqrt(distance_from_destination + route_distance - distance_from_origin)

    area = (0.25 * root1 * root2 * root3 * root4)

    2 * area / route_distance
  end

  def filter_routes(order_coords, routes)
    routes.select do |route|
      route.in_range?(order_coords, route)
    end
  end
end
