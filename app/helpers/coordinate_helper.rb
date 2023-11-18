module CoordinateHelper
  module_function

  def deg2rad(lat, long)
    [(lat * Math::PI / 180), (long * Math::PI / 180)]
  end

  # rubocop:disable Metrics/AbcSize
  def spherical_distance(start_coords, end_coords)
    radius = 6372.8 # rough radius of the Earth, in kilometers
    lat1, long1 = deg2rad(start_coords[:latitude], start_coords[:longitude])
    lat2, long2 = deg2rad(end_coords[:latitude], end_coords[:longitude])

    2 * radius * asin(sqrt((sin((lat2 - lat1) / 2)**2) + (cos(lat1) * cos(lat2) * (sin((long2 - long1) / 2)**2))))
  end
  # rubocop:enable Metrics/AbcSize
end
