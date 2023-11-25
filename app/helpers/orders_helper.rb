module OrdersHelper
  include CoordinateHelper

  def order_coords(order)
    return [order.origin, order.destination] if order.instance_of?(Order)

    pickup_coords = {
      latitude: order[:pick_up][:latitude].to_f,
      longitude: order[:pick_up][:longitude].to_f
    }

    dropoff_coords = {
      latitude: order[:drop_off][:latitude].to_f,
      longitude: order[:drop_off][:longitude].to_f
    }
    [pickup_coords, dropoff_coords]
  end

  def in_range?(order_coords, route, proximity)
    distance_from_origin, distance_from_destination = get_distances(order_coords, route)

    return true if distance_from_origin < 1 || distance_from_destination < 1

    triangular_height = get_triangular_height(
      distance_from_origin,
      distance_from_destination,
      route.route_distance
    )

    triangular_height < proximity
  end

  def profitability(order, route)
    pickup_coords, dropoff_coords = order_coords(order)

    pickup_origin_distance, pickup_destination_distance = get_distances(pickup_coords, route)

    triangular_height = get_triangular_height(
      pickup_origin_distance,
      pickup_destination_distance,
      route.route_distance
    )
    triangular_height *= triangular_height

    hypotenuse = get_hypotenuse(pickup_coords, dropoff_coords, route)

    distance_from_pickup_to_dropoff = sqrt((hypotenuse * hypotenuse) + triangular_height)

    total_distance = distance_from_pickup_to_dropoff + triangular_height

    calculate_package_cost(total_distance, triangular_height, route)
  end

  def calculate_package_cost(total_distance, triangular_height, route)
    extra_driving_cost = (triangular_height * 2) * route.truck.total_costs_per_mile

    package_distance_cost = total_distance * 1.6 * 0.02 * (1 + route.markup)

    package_distance_cost - extra_driving_cost
  end
end
