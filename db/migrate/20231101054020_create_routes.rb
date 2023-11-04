class CreateRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :routes do |t|
      t.integer :origin_id
      t.integer :destination_id
      t.string :path
      t.string :anchor_point
      t.float :miles_with_cargo
      t.float :total_miles
      t.float :operational_truck_cost
      t.integer :pallets
      t.float :cargo_cost
      t.float :empty_cargo_cost
      t.float :markup
      t.float :price_based_on_total_cost
      t.float :price_based_on_cargo_cost
      t.float :margin
      t.integer :pickup_dropoff_qty
      t.float :time_hours
      t.string :contract_name

      t.timestamps
    end
  end
end
