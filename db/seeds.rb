# db/seeds.rb

# Create some clients
client1 = Client.create
client2 = Client.create

# Create some locations
location1 = Location.create(latitude: 40.7128, longitude: -74.0060)
location2 = Location.create(latitude: 34.0522, longitude: -118.2437)

# Create some routes
route1 = Route.create(origin_id: location1.id, destination_id: location2.id, profitability: 0.8)
route2 = Route.create(origin_id: location2.id, destination_id: location1.id, profitability: 0.9)

# Create some orders
order1 = Order.create(origin_id: location1.id, destination_id: location2.id, client: client1, route: route1)
order2 = Order.create(origin_id: location2.id, destination_id: location1.id, client: client2, route: route2)

# Create some trucks
truck1 = Truck.create(autonomy: true, capacity: 100, truck_type: "Truck Type A")
truck2 = Truck.create(autonomy: false, capacity: 200, truck_type: "Truck Type B")

# Create some cargos
cargo1 = Cargo.create(order: order1, truck: truck1)
cargo2 = Cargo.create(order: order2, truck: truck2)

# Create some packages
package1 = Package.create(volume: 10, weight: 50, package_type: "Package Type X", cargo: cargo1)
package2 = Package.create(volume: 20, weight: 30, package_type: "Package Type Y", cargo: cargo2)

# Add more seed data as needed

puts "Seed data created successfully."
