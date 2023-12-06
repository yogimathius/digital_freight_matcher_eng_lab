# app/models/truck.rb

class Truck < ApplicationRecord
  has_one :cargo, dependent: :destroy

  validates :autonomy, inclusion: { in: [true, false] }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :truck_type, presence: true
  validates :total_costs_per_mile, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :trucker_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fuel_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :leasing_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :maintenance_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :insurance_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :miles_per_gallon, presence: true, numericality: { greater_than: 0 }
  validates :gas_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :avg_speed_miles_per_hour, presence: true, numericality: { greater_than: 0 }
  # has_many :cargos, dependent: :destroy
  belongs_to :route

  MAX_WEIGHT = 9180
  MAX_VOLUME = 1700
  PALLET_WEIGHT = 440
  PALLET_VOLUME = 64

  def capacity?(cargo_arg)
    return true if cargo.nil?

    total_cargo_arg_weight = cargo_arg.packages.sum(&:weight)
    total_cargo_arg_volume = cargo_arg.packages.sum(&:volume)

    return true if truck_cargo_weight + total_cargo_arg_weight <= MAX_WEIGHT && truck_cargo_volume + total_cargo_arg_volume <= MAX_VOLUME

    false
  end

  def truck_cargo_weight
    cargo.packages.sum(&:weight) + pallet_weight
  end

  def truck_cargo_volume
    cargo.packages.sum(&:volume) + pallet_volume
  end

  def pallet_weight
    route.pallets * PALLET_WEIGHT
  end

  def pallet_volume
    route.pallets * PALLET_VOLUME
  end
end
