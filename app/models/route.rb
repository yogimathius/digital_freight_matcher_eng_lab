class Route < ApplicationRecord
  include Math
  include CoordinateHelper
  include GeometryHelper

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_one :truck, dependent: :destroy
  has_many :orders, dependent: :destroy

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

    return true unless distance_from_origin > 1 && distance_from_destination > 1

    triangular_height = get_triangular_height(
      distance_from_origin,
      distance_from_destination,
      route_distance
    )
    Rails.logger.debug triangular_height
    triangular_height < 1
  end
end
