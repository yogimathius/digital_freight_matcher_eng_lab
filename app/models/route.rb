class Route < ApplicationRecord
  include Math
  include CoordinateHelper

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_one :truck, dependent: :destroy
  has_many :orders, dependent: :destroy

  def in_range?(order_coords)
    OrderService.in_range?(order_coords, route_distance)
  end

  def profitability(order)
    OrderService.profitability(order, self, route_distance)
  end

  def route_distance
    spherical_distance(
      origin,
      destination
    )
  end
end
