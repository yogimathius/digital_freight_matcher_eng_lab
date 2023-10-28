class Route < ApplicationRecord
  include Math

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_many :orders, dependent: :destroy

  def spherical_distance(start_coords, end_coords)
    radius = 6372.8 # rough radius of the Earth, in kilometers
    lat1, long1 = deg2rad(start_coords[:latitude], start_coords[:longitude])
    lat2, long2 = deg2rad(end_coords[:latitude], end_coords[:longitude])

    2 * radius * asin(sqrt((sin((lat2 - lat1) / 2)**2) + (cos(lat1) * cos(lat2) * (sin((long2 - long1) / 2)**2))))
  end

  def deg2rad(lat, long)
    [(lat * Math::PI / 180), (long * Math::PI / 180)]
  end

  # Using Heron's formula:
  def get_triangular_height(
    distance_from_origin,
    distance_from_destination,
    route_distance
  )
    s = (distance_from_origin + distance_from_destination + route_distance) / 2.0
    area = Math.sqrt(s * (s - distance_from_origin) * (s - distance_from_destination) * (s - route_distance))
  
    # Height of the triangle
    triangular_height = 2 * area / route_distance
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
    # binding.break
    if distance_from_origin < 1 || distance_from_destination < 1
      # binding.break
      return true
    end

    # if distance_from_origin < 1 || distance_from_destination < 1
      # binding.break
      # return true
    # end
    # b
    triangular_height = get_triangular_height(distance_from_origin,     distance_from_destination,route_distance)
    puts triangular_height
    triangular_height < 1
  end
end
