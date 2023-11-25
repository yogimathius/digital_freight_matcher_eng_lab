module CoordinateHelper
  module_function

  include Math

  def deg2rad(lat, long)
    [(lat * Math::PI / 180), (long * Math::PI / 180)]
  end

  # rubocop:disable Metrics/AbcSize
  def spherical_distance(start_coords, end_coords)
    radius = 6372.8 # rough radius of the Earth, in kilometers
    lat1, long1 = deg2rad(start_coords[:latitude].to_f, start_coords[:longitude].to_f)
    lat2, long2 = deg2rad(end_coords[:latitude].to_f, end_coords[:longitude].to_f)

    2 * radius * asin(sqrt((sin((lat2 - lat1) / 2)**2) + (cos(lat1) * cos(lat2) * (sin((long2 - long1) / 2)**2))))
  end
  # rubocop:enable Metrics/AbcSize

  def get_distances(order_coords, route)
    distance_from_origin = spherical_distance(
      order_coords,
      route.origin
    )

    distance_from_destination = spherical_distance(
      order_coords,
      route.destination
    )

    [distance_from_origin, distance_from_destination]
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
    # α = acos(((route_distance ** 2) + (distance_from_destination ** 2 )- (distance_from_origin ** 2)) / (2 * route_distance * distance_from_destination))
    area = (0.25 * root1 * root2 * root3 * root4)

    2 * area / route_distance
  end

  def get_hypotenuse(pickup_coords, dropoff_coords, route)
    pickup_origin_distance, = get_distances(pickup_coords, route)

    dropoff_origin_distance, dropoff_destination_distance = get_distances(dropoff_coords, route)

    pickup_origin_distance < dropoff_origin_distance ? dropoff_origin_distance : dropoff_destination_distance
  end
end
