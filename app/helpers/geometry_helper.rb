module GeometryHelper
  module_function

  # Using Heron's formula:
  def get_triangular_height(
    distance_from_origin,
    distance_from_destination,
    route_distance
  )
    root1 = Math.sqrt(distance_from_destination + route_distance + distance_from_origin)
    root2 = Math.sqrt(-distance_from_destination + route_distance + distance_from_origin)
    root3 = Math.sqrt(distance_from_destination - route_distance + distance_from_origin)
    root4 = Math.sqrt(distance_from_destination + route_distance - distance_from_origin)
    # α = acos(((route_distance ** 2) + (distance_from_destination ** 2 )- (distance_from_origin ** 2)) / (2 * route_distance * distance_from_destination))
    area = (0.25 * root1 * root2 * root3 * root4)

    2 * area / route_distance
  end
end