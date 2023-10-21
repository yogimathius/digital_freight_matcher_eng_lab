class UpdateRoutes < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :anchor_point, :string
    add_column :routes, :miles_with_cargo, :float
    add_column :routes, :total_miles, :float
    add_column :routes, :operational_truck_cost, :float
    add_column :routes, :pallets, :integer
    add_column :routes, :cargo_cost, :float
    add_column :routes, :empty_cargo_cost, :float
    add_column :routes, :markup, :float
    add_column :routes, :price_based_on_total_cost, :float
    add_column :routes, :price_based_on_cargo_cost, :float
    add_column :routes, :margin, :float
    add_column :routes, :pickup_dropoff_qty, :integer
    add_column :routes, :time_hours, :float
  end
end
