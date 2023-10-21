# db/seeds.rb

# Create some clients
client1 = Client.create!
client2 = Client.create!

# Create some locations
location1 = Location.create!(latitude: 40.7128, longitude: -74.0060)
location2 = Location.create!(latitude: 34.0522, longitude: -118.2437)



# Create some routes
route1 = Route.create!(origin_id: location1.id, destination_id: location2.id, profitability: 0.8,
                       anchor_point: "Ringgold", miles_with_cargo: 101.0,
                       total_miles: 202.0, operational_truck_cost: 367.02, pallets: 12,
                       cargo_cost: 165.80599, empty_cargo_cost: 201.21, markup: 0.5,
                       price_based_on_total_cost: 550.53, price_based_on_cargo_cost: 248.708981,
                       margin: -0.3224, pickup_dropoff_qty: 2, time_hours: 4.0)

route2 = Route.create!(origin_id: location2.id, destination_id: location1.id, profitability: 0.9,
                       anchor_point: "Augusta", miles_with_cargo: 94.6,
                       total_miles: 189.2, operational_truck_cost: 343.76, pallets: 10,
                       cargo_cost: 129.41622, empty_cargo_cost: 214.35, markup: 0.5,
                       price_based_on_total_cost: 515.64, price_based_on_cargo_cost: 194.1243367,
                       margin: -0.4353, pickup_dropoff_qty: 2, time_hours: 3.8)

route3 = Route.create!(origin_id: location1.id, destination_id: location2.id, profitability: 0.8,
                       anchor_point: "Savannah", miles_with_cargo: 248.0,
                       total_miles: 496.0, operational_truck_cost: 901.19, pallets: 11,
                       cargo_cost: 373.20028, empty_cargo_cost: 527.99, markup: 0.5,
                       price_based_on_total_cost: 1351.79, price_based_on_cargo_cost: 559.8004127,
                       margin: -0.3788, pickup_dropoff_qty: 2, time_hours: 9.9)

route4 = Route.create!(origin_id: location2.id, destination_id: location1.id, profitability: 0.9,
                       anchor_point: "Albany", miles_with_cargo: 182.0,
                       total_miles: 364.0, operational_truck_cost: 661.36, pallets: 12,
                       cargo_cost: 298.77911, empty_cargo_cost: 362.58, markup: 0.5,
                       price_based_on_total_cost: 992.04, price_based_on_cargo_cost: 448.1686588,
                       margin: -0.3224, pickup_dropoff_qty: 2, time_hours: 7.3)

route5 = Route.create!(origin_id: location1.id, destination_id: location2.id, profitability: 0.8,
                       anchor_point: "Columbus", miles_with_cargo: 107.0,
                       total_miles: 214.0, operational_truck_cost: 388.82, pallets: 9,
                       cargo_cost: 131.74189, empty_cargo_cost: 257.08, markup: 0.5,
                       price_based_on_total_cost: 583.23, price_based_on_cargo_cost: 197.612829,
                       margin: -0.4918, pickup_dropoff_qty: 2, time_hours: 4.3)

order1 = Order.create!(origin_id: location1.id, destination_id: location2.id, client: client1, route: route1)
order2 = Order.create!(origin_id: location2.id, destination_id: location1.id, client: client2, route: route2)

# Create some trucks
truck1 = Truck.create!(autonomy: true, capacity: 100, truck_type: "Truck Type A",
  total_costs_per_mile: 1.816923077, trucker_cost: 0.78, fuel_cost: 0.50,
  leasing_cost: 0.27, maintenance_cost: 0.17, insurance_cost: 0.10,
  miles_per_gallon: 6.5, gas_price: 3.23, avg_speed_miles_per_hour: 50.0)

truck2 = Truck.create!(autonomy: false, capacity: 200, truck_type: "Truck Type B",
  total_costs_per_mile: 1.816923077, trucker_cost: 0.78, fuel_cost: 0.50,
  leasing_cost: 0.27, maintenance_cost: 0.17, insurance_cost: 0.10,
  miles_per_gallon: 6.5, gas_price: 3.23, avg_speed_miles_per_hour: 50.0)


# Create some cargos
cargo1 = Cargo.create!(order: order1, truck: truck1,
                      max_weight_lbs: 9180, total_volume_cubic_feet: 1700,
                      pallet_per_truck: 26.6, pallet_cost_per_mile: 0.07,
                      std_package_per_truck: 94.4, std_package_cost_per_mile: 0.02)

cargo2 = Cargo.create!(order: order2, truck: truck2,
                      max_weight_lbs: 9180, total_volume_cubic_feet: 1700,
                      pallet_per_truck: 26.6, pallet_cost_per_mile: 0.07,
                      std_package_per_truck: 94.4, std_package_cost_per_mile: 0.02)

# Create some packages
package1 = Package.create!(volume: 10, weight: 50, package_type: "Package Type X", cargo: cargo1)
package2 = Package.create!(volume: 20, weight: 30, package_type: "Package Type Y", cargo: cargo2)


puts "Seed data created successfully."

