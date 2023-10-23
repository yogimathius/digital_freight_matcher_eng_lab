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
      return [@mock_route]
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


Radius = 6372.8  # rough radius of the Earth, in kilometers

def spherical_distance(start_coords, end_coords)
  lat1, long1 = deg2rad *start_coords
  lat2, long2 = deg2rad *end_coords
  2 * Radius * asin(sqrt((sin((lat2-lat1)/2)**2) + (cos(lat1) * cos(lat2) * (sin((long2 - long1)/2)**2))))
end

def deg2rad(lat, long)
  [lat * PI / 180, long * PI / 180]
end

bna = [36.12, -86.67]
lax = [33.94, -118.4]

Rails.logger.debug "%.1f" % spherical_distance(bna, lax)
end
