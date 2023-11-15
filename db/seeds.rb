# Create some clients
client1 = Client.create!
client2 = Client.create!

# Create some locations
atlanta = Location.create!(
  latitude: 33.7488,
  longitude: -84.3877
)

ringgold = Location.create!(
  latitude: 34.9249,
  longitude: -85.1098
)

augusta = Location.create!(
  latitude: 33.4735,
  longitude: -82.0105
)

savannah = Location.create!(
  latitude: 32.0809,
  longitude: -81.0912
)

albany = Location.create!(
  latitude: 31.5785,
  longitude: -84.1558
)

columbus = Location.create!(
  latitude: 32.4610,
  longitude: -84.9877
)

# Create some routes
# Route 1: Ringgold
route1 = Route.create!(
  origin_id: atlanta.id,
  destination_id: ringgold.id,
  anchor_point: "Ringgold",
  miles_with_cargo: 101.0,
  total_miles: 202.0,
  operational_truck_cost: 342.16,
  pallets: 20,
  cargo_cost: 257.62404,
  empty_cargo_cost: 84.53,
  markup: 0.5,
  price_based_on_total_cost: 513.24,
  price_based_on_cargo_cost: 386.4360543,
  margin: 12.94,
  pickup_dropoff_qty: 2,
  time_hours: 4.0,
  contract_name: "Incurred"
)

# Route 2: Augusta
route2 = Route.create!(
  origin_id: atlanta.id,
  destination_id: augusta.id,
  anchor_point: "Augusta",
  miles_with_cargo: 94.6,
  total_miles: 189.2,
  operational_truck_cost: 320.48,
  pallets: 21,
  cargo_cost: 253.364312,
  empty_cargo_cost: 67.11,
  markup: 0.5,
  price_based_on_total_cost: 480.71,
  price_based_on_cargo_cost: 380.0464681,
  margin: 18.59,
  pickup_dropoff_qty: 2,
  time_hours: 3.8,
  contract_name: "Incurred"
)

# Route 3: Savannah
route3 = Route.create!(
  origin_id: atlanta.id,
  destination_id: savannah.id,
  anchor_point: "Savannah",
  miles_with_cargo: 248.0,
  total_miles: 496.0,
  operational_truck_cost: 840.15,
  pallets: 22,
  cargo_cost: 695.839971,
  empty_cargo_cost: 144.31,
  markup: 0.5,
  price_based_on_total_cost: 1260.22,
  price_based_on_cargo_cost: 1043.759957,
  margin: 24.24,
  pickup_dropoff_qty: 2,
  time_hours: 9.9,
  contract_name: "Incurred"
)

# Route 4: Albany
route4 = Route.create!(
  origin_id: atlanta.id,
  destination_id: albany.id,
  anchor_point: "Albany",
  miles_with_cargo: 182.0,
  total_miles: 364.0,
  operational_truck_cost: 616.56,
  pallets: 17,
  cargo_cost: 394.5984,
  empty_cargo_cost: 221.96,
  markup: 0.5,
  price_based_on_total_cost: 924.84,
  price_based_on_cargo_cost: 591.8976,
  margin: -4.00,
  pickup_dropoff_qty: 2,
  time_hours: 7.3,
  contract_name: "Incurred"
)

# Route 5: Columbus
route5 = Route.create!(
  origin_id: atlanta.id,
  destination_id: columbus.id,
  anchor_point: "Columbus",
  miles_with_cargo: 107.0,
  total_miles: 214.0,
  operational_truck_cost: 362.48,
  pallets: 18,
  cargo_cost: 245.635591,
  empty_cargo_cost: 116.85,
  markup: 0.5,
  price_based_on_total_cost: 543.72,
  price_based_on_cargo_cost: 368.4533864,
  margin: 1.65,
  pickup_dropoff_qty: 2,
  time_hours: 4.3,
  contract_name: "Incurred"
)

# Create some orders
order1 = Order.create!(
  origin_id: ringgold.id,
  destination_id: atlanta.id,
  client: client1,
  route: route1
)
order2 = Order.create!(
  origin_id: atlanta.id,
  destination_id: ringgold.id,
  client: client2,
  route: route2
)

# Create some trucks
truck1 = Truck.create!(
  autonomy: true,
  capacity: 100,
  truck_type: "Truck Type A",
  total_costs_per_mile: 1.816923077,
  trucker_cost: 0.78,
  fuel_cost: 0.50,
  leasing_cost: 0.27,
  maintenance_cost: 0.17,
  insurance_cost: 0.10,
  miles_per_gallon: 6.5,
  gas_price: 3.23,
  avg_speed_miles_per_hour: 50.0,
  route_id: route1.id
)

truck2 = Truck.create!(
  autonomy: true,
  capacity: 100,
  truck_type: "Truck Type A",
  total_costs_per_mile: 1.816923077,
  trucker_cost: 0.78,
  fuel_cost: 0.50,
  leasing_cost: 0.27,
  maintenance_cost: 0.17,
  insurance_cost: 0.10,
  miles_per_gallon: 6.5,
  gas_price: 3.23,
  avg_speed_miles_per_hour: 50.0,
  route_id: route2.id
)

truck3 = Truck.create!(
  autonomy: true,
  capacity: 100,
  truck_type: "Truck Type A",
  total_costs_per_mile: 1.816923077,
  trucker_cost: 0.78,
  fuel_cost: 0.50,
  leasing_cost: 0.27,
  maintenance_cost: 0.17,
  insurance_cost: 0.10,
  miles_per_gallon: 6.5,
  gas_price: 3.23,
  avg_speed_miles_per_hour: 50.0,
  route_id: route3.id
)

truck4 = Truck.create!(
  autonomy: true,
  capacity: 100,
  truck_type: "Truck Type A",
  total_costs_per_mile: 1.816923077,
  trucker_cost: 0.78,
  fuel_cost: 0.50,
  leasing_cost: 0.27,
  maintenance_cost: 0.17,
  insurance_cost: 0.10,
  miles_per_gallon: 6.5,
  gas_price: 3.23,
  avg_speed_miles_per_hour: 50.0,
  route_id: route4.id
)

truck5 = Truck.create!(
  autonomy: true,
  capacity: 100,
  truck_type: "Truck Type A",
  total_costs_per_mile: 1.816923077,
  trucker_cost: 0.78,
  fuel_cost: 0.50,
  leasing_cost: 0.27,
  maintenance_cost: 0.17,
  insurance_cost: 0.10,
  miles_per_gallon: 6.5,
  gas_price: 3.23,
  avg_speed_miles_per_hour: 50.0,
  route_id: route5.id
)

# Repeat the same formatting for truck2

# Create some cargos
cargo1 = Cargo.create!(
  order: order1,
  truck: truck1
)

# Repeat the same formatting for cargo2

# Create some packages
package1 = Package.create!(
  volume: 10,
  weight: 50,
  package_type: "Package Type X",
  cargo: cargo1
)

# Repeat the same formatting for package2

Rails.logger.debug "Seed data created successfully."
