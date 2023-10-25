class Route < ApplicationRecord
  include Math

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_many :orders, dependent: :destroy

  def spherical_distance(start_coords, end_coords)
    radius = 6372.8 # rough radius of the Earth, in kilometers
    lat1, long1 = deg2rad(*start_coords)
    lat2, long2 = deg2rad(*end_coords)
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

  def in_range?(order_coords, route)
    distance_from_origin = spherical_distance(
      order_coords,
      route.origin
    )

    distance_from_destination = spherical_distance(
      order_coords,
      route.destination
    )

    route_distance = spherical_distance(
      route.origin,
      route.destination
    )

    triangular_height = get_triangular_height(
      distance_from_origin,
      distance_from_destination,
      route_distance
    )

    triangular_height < 1
  end
end
