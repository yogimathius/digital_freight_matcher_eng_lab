class RemoveFieldsFromCargo < ActiveRecord::Migration[7.0]
  def change
    remove_column :cargos, :max_weight_lbs, :integer
    remove_column :cargos, :total_volume_cubic_feet, :integer
    remove_column :cargos, :pallet_per_truck, :float
    remove_column :cargos, :pallet_cost_per_mile, :float
    remove_column :cargos, :std_package_per_truck, :float
    remove_column :cargos, :std_package_cost_per_mile, :float
  end
end
