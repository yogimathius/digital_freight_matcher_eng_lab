class OrderService
  extend CoordinateHelper

  def self.order_coords(order)
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

  def self.in_range?(order_coords, route)
    distance_from_origin, distance_from_destination = get_distances(order_coords, route)

    return true if distance_from_origin < 1 || distance_from_destination < 1

    triangular_height = get_triangular_height(
      distance_from_origin,
      distance_from_destination,
      route.route_distance
    )

    triangular_height < 1
  end

  def self.profitability(order, route, route_distance)
    pickup_coords, dropoff_coords = order_coords(order)

    pickup_origin_distance, pickup_destination_distance = get_distances(pickup_coords, route)

    dropoff_origin_distance, dropoff_destination_distance = get_distances(dropoff_coords, route)

    triangular_height = get_triangular_height(
      pickup_origin_distance,
      pickup_destination_distance,
      route_distance
    )

    hypotenuse = pickup_origin_distance < dropoff_origin_distance ? dropoff_origin_distance : dropoff_destination_distance

    triangular_height *= triangular_height

    distance_from_pickup_to_dropoff = sqrt((hypotenuse * hypotenuse) + triangular_height)

    total_distance = distance_from_pickup_to_dropoff + triangular_height

    ((total_distance * 1.6) * 0.02) * 1.50
  end
end
