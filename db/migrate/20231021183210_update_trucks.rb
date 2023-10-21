class UpdateTrucks < ActiveRecord::Migration[7.0]
  def change
    add_column :trucks, :total_costs_per_mile, :float
    add_column :trucks, :trucker_cost, :float
    add_column :trucks, :fuel_cost, :float
    add_column :trucks, :leasing_cost, :float
    add_column :trucks, :maintenance_cost, :float
    add_column :trucks, :insurance_cost, :float
    add_column :trucks, :miles_per_gallon, :float
    add_column :trucks, :gas_price, :float
    add_column :trucks, :avg_speed_miles_per_hour, :float
  end
end
