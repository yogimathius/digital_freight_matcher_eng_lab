module RoutesHelper
  include CoordinateHelper
  include OrdersHelper

  KM_MULTIPLIER = 1.60934
  PICKUP_DROPOFF_TIME_HOURS = 0.5
  MAX_DEVIATION_DISTANCE_MI = 2 / KM_MULTIPLIER
  MAX_SHIFT_DURATION = 10

  def calculate_order_deviation_time(route)
    deviation_time = MAX_DEVIATION_DISTANCE_MI / route.truck.avg_speed_miles_per_hour
    deviation_time + PICKUP_DROPOFF_TIME_HOURS
  end

  def schedule_on_return?(order, route)
    pickup_coords, dropoff_coords = order_coords(order)

    _, pickup_destination_distance = get_distances(pickup_coords, route)
    _, dropoff_destination_distance = get_distances(dropoff_coords, route)

    pickup_destination_distance < dropoff_destination_distance
  end
end
