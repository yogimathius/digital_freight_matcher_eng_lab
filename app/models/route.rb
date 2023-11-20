class Route < ApplicationRecord
  include Math
  include CoordinateHelper

  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_one :truck, dependent: :destroy
  has_many :orders, dependent: :destroy

  def profitability(order)
    OrderService.profitability(order, self, route_distance)
  end

  def route_distance
    spherical_distance(
      origin,
      destination
    )
  end

  def route_profit
    order_profits = orders.map do |order|
      order.cargo.packages.map do
        profitability(order)
      end.sum
    end.sum

    price_based_on_cargo_cost + order_profits
  end
end
