class Truck < ApplicationRecord
  has_many :cargos, dependent: :destroy
  belongs_to :route

  attr_reader :max_weight, :max_volume, :pallet_weight, :pallet_volume, :std_package_weight, :std_package_volume, :pallets_capacity, :std_packages_capacity

  def initialize
    @max_weight = 9_180  
    @max_volume = 1_700  
    @pallet_weight = 440  
    @pallet_volume = 64   
    @std_package_weight = 66 
    @std_package_volume = 18  
    @pallets_capacity = (max_weight / pallet_weight).to_i  
    @std_packages_capacity = (max_volume / std_package_volume).to_i  
 end

  def capacity_by_weight
    "The truck can carry up to #{@pallets_capacity} pallets based on weight (limited by max weight of #{@max_weight} lbs.)"
  end

  def capacity_by_volume
    "The truck can carry up to #{@std_packages_capacity} standard packages based on volume (limited by max volume of #{@max_volume} cubic feet)"
  end

  def capacity_combined
    "The truck can carry up to #{@pallets_capacity} pallets or #{@std_packages_capacity} standard packages (whichever is more limiting)"
  end

  def has_capacity?(cargo)
    total_cargo_weight = cargo[:packages].sum 
    total_cargo_volume = cargo[:packages].volume

    if total_cargo_weight <= max_weight && total_cargo_volume <= max_volume
      return true  
    else
      return false  
    end
  end
end

    
  end
end
