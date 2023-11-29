require 'geocoder'

module CoordinateHelper
  module_function

  include Math
  KM_MULTIPLIER = 1.60934

  # rubocop:disable Metrics/AbcSize
  def get_distances(order_coords, route)
    distance_from_origin = Geocoder::Calculations.distance_between(
      [order_coords[:latitude].to_f, order_coords[:longitude].to_f],
      [route.origin.latitude, route.origin.longitude]
    ) * KM_MULTIPLIER

    distance_from_destination = Geocoder::Calculations.distance_between(
      [order_coords[:latitude].to_f, order_coords[:longitude].to_f],
      [route.destination.latitude, route.destination.longitude]
    ) * KM_MULTIPLIER

    [distance_from_origin, distance_from_destination]
  end
  # rubocop:enable Metrics/AbcSize

  # Using Heron's formula:
  def get_triangular_height(route_distance, distance_from_origin, distance_from_destination)
    s = (route_distance + distance_from_origin + distance_from_destination) / 2.0
    area = Math.sqrt(s * (s - route_distance) * (s - distance_from_origin) * (s - distance_from_destination))
    2 * area / route_distance
  end

  def get_hypotenuse(pickup_coords, dropoff_coords, route)
    pickup_origin_distance, = get_distances(pickup_coords, route)

    dropoff_origin_distance, dropoff_destination_distance = get_distances(dropoff_coords, route)

    pickup_origin_distance < dropoff_origin_distance ? dropoff_origin_distance : dropoff_destination_distance
  end
end
