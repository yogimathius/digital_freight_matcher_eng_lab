class UpdateCargos < ActiveRecord::Migration[7.0]
  def change
    add_column :cargos, :max_weight_lbs, :integer
    add_column :cargos, :total_volume_cubic_feet, :integer
    add_column :cargos, :pallet_per_truck, :float
    add_column :cargos, :pallet_cost_per_mile, :float
    add_column :cargos, :std_package_per_truck, :float
    add_column :cargos, :std_package_cost_per_mile, :float
  end
end
