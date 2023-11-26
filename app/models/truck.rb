# app/models/truck.rb

class Truck < ApplicationRecord
  belongs_to :route

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
end
