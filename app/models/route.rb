class Route < ApplicationRecord
  include Math
  include CoordinateHelper
  include GeometryHelper

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_one :truck, dependent: :destroy
  has_many :orders, dependent: :destroy

  def get_distances(order_coords)
    distance_from_origin = spherical_distance(
      order_coords,
      origin
    )

    distance_from_destination = spherical_distance(
      order_coords,
      destination
    )

    [distance_from_origin, distance_from_destination]
  end

  def order_coords(order)
    pickup_coords = {
      latitude: order[:pick_up][:latitude],
      longitude: order[:pick_up][:longitude]
    }

    dropoff_coords = {
      latitude: order[:drop_off][:latitude],
      longitude: order[:drop_off][:longitude]
    }
    [pickup_coords, dropoff_coords]
  end

  def in_range?(order_coords)
    distance_from_origin, distance_from_destination = get_distances(order_coords)

    return true if distance_from_origin < 1 || distance_from_destination < 1

    triangular_height = get_triangular_height(
      distance_from_origin,
      distance_from_destination,
      route_distance
    )
    Rails.logger.debug triangular_height
    triangular_height < 1
  end

  def profitability(order)
    pickup_coords, dropoff_coords = order_coords(order)

    pickup_origin_distance, pickup_destination_distance = get_distances(pickup_coords)

    dropoff_origin_distance, dropoff_destination_distance = get_distances(dropoff_coords)

    pickup_from_origin = pickup_origin_distance < dropoff_origin_distance

    hypotenuse = pickup_from_origin ? dropoff_origin_distance : dropoff_destination_distance

    hypotenuse *= hypotenuse

    triangular_height = get_triangular_height(
      pickup_origin_distance,
      pickup_destination_distance,
      route_distance
    )

    triangular_height *= triangular_height

    distance_from_pickup_to_dropoff = sqrt(hypotenuse + triangular_height)

    total_distance = distance_from_pickup_to_dropoff + triangular_height

    # return total cost per kilometer
    # multiply by 1.6 to get per km value
    ((total_distance * 1.6) * 0.02) * 1.50
  end

  def route_distance
    spherical_distance(
      origin,
      destination
    )
  end
end
