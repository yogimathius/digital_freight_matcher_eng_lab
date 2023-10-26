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
    if is_valid_order?(order)
      pickup_coords = {
        latitude: order["pick_up"]["latitude"],
        longitude: order["pick_up"]["longitude"]
      }
      # binding.break
      dropoff_coords = {
        latitude: order["drop_off"]["latitude"],
        longitude: order["drop_off"]["longitude"]
      }

      # Find matching routes for proximity (within 1 km)
      matching_routes = Route.select do |route|
        binding.break
        route.in_range?(pickup_coords, route) &&
          route.in_range?(dropoff_coords, route)
      end


      # Check truck package capacity (make sure order doesn’t overload truck)
      # Check truck shift duration (route doesn’t exceed 10 hrs)
      # How to store array of profitable routes?

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
end
