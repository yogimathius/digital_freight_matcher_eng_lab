module RoutesHelper
  include CoordinateHelper
  include OrdersHelper

  PICKUP_DROPOFF_TIME_HOURS = 0.5
  MAX_DEVIATION_DISTANCE_MI = 2 / 1.609
  MAX_SHIFT_DURATION = 10

  def calculate_order_deviation_time(route)
    deviation_time = MAX_DEVIATION_DISTANCE_MI / route.truck.avg_speed_miles_per_hour
    deviation_time + PICKUP_DROPOFF_TIME_HOURS
  end

  def fits_in_shift?(_order, route)
    order_deviation_time = calculate_order_deviation_time(route)
    total_route_deviation_time = route.orders.map { |_order| calculate_order_deviation_time(route) }.sum
    current_route_time = total_route_deviation_time + route.time_hours

    current_route_time + order_deviation_time < MAX_SHIFT_DURATION
  end

  def schedule_on_return?(order, route)
    pickup_coords, dropoff_coords = order_coords(order)

    _, pickup_destination_distance = get_distances(pickup_coords, route)
    _, dropoff_destination_distance = get_distances(dropoff_coords, route)

    pickup_destination_distance < dropoff_destination_distance
  end
end
