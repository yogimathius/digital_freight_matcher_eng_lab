module RoutesHelper
  include CoordinateHelper

  PICKUP_DROPOFF_TIME_HOURS = 0.5
  MAX_DEVIATION_DISTANCE_MI = 2 / 1.609
  MAX_SHIFT_DURATION = 10

  def calculate_order_deviation_time(route)
    deviation_time = MAX_DEVIATION_DISTANCE_MI / route.truck.avg_speed_miles_per_hour
    deviation_time + PICKUP_DROPOFF_TIME_HOURS
  end

  def fits_in_shift?(order, route)
    order_deviation_time = calculate_order_deviation_time(route)
    total_route_deviation_time = route.orders.map { |order| calculate_order_deviation_time(route) }.sum
    current_route_time = total_route_deviation_time + route.time_hours

    current_route_time + order_deviation_time < MAX_SHIFT_DURATION
  end
end
