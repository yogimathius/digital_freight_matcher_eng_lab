# app/models/truck.rb

class Truck < ApplicationRecord
  belongs_to :route
  has_one :cargo

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
  has_many :cargos, dependent: :destroy
  belongs_to :route

  def has_capacity?(cargo_arg)
    @max_weight = 9180
    @max_volume = 1700

    total_cargo_weight = cargo.packages.sum(&:weight)
    total_cargo_volume = cargo.packages.sum(&:volume)

    total_cargo_arg_weight = cargo_arg.packages.sum(&:weight)
    total_cargo_arg_volume = cargo_arg.packages.sum(&:volume)

    if total_cargo_weight + total_cargo_arg_weight <= @max_weight && total_cargo_volume + total_cargo_arg_volume <= @max_volume
      return true
    else
      return false
    end
  end
end
