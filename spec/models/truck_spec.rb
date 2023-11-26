# spec/models/truck_spec.rb

require 'rails_helper'

RSpec.describe Truck, type: :model do
  subject do
    described_class.new(
      autonomy: true,
      capacity: 100,
      truck_type: 'Semi-Truck',
      total_costs_per_mile: 1.5,
      trucker_cost: 100,
      fuel_cost: 50,
      leasing_cost: 200,
      maintenance_cost: 30,
      insurance_cost: 20,
      miles_per_gallon: 5,
      gas_price: 2.5,
      avg_speed_miles_per_hour: 60,
      route_id: 1
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without autonomy" do
    subject.autonomy = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without capacity" do
    subject.capacity = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without truck_type" do
    subject.truck_type = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without total_costs_per_mile" do
    subject.total_costs_per_mile = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without trucker_cost" do
    subject.trucker_cost = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without fuel_cost" do
    subject.fuel_cost = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without leasing_cost" do
    subject.leasing_cost = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without maintenance_cost" do
    subject.maintenance_cost = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without insurance_cost" do
    subject.insurance_cost = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without miles_per_gallon" do
    subject.miles_per_gallon = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without gas_price" do
    subject.gas_price = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without avg_speed_miles_per_hour" do
    subject.avg_speed_miles_per_hour = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without route_id" do
    subject.route_id = nil
    expect(subject).to_not be_valid
  end

  it "belongs to a route" do
    expect(subject).to respond_to(:route)
  end
end
