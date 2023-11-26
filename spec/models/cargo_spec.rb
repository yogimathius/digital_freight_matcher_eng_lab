# spec/models/cargo_spec.rb

require 'rails_helper'

RSpec.describe Cargo, type: :model do
  subject do
    described_class.new(order_id: 1,
                        truck_id: 2)
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without an order_id" do
    subject.order_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a truck_id" do
    subject.truck_id = nil
    expect(subject).to_not be_valid
  end

  it "associates with an order" do
    expect(subject).to respond_to(:order)
  end

  it "associates with a truck" do
    expect(subject).to respond_to(:truck)
  end

  it "has many packages" do
    expect(subject).to respond_to(:packages)
  end

  it "destroys associated packages when destroyed" do
    cargo = Cargo.create(order_id: 1, truck_id: 2)
    cargo.packages.create(volume: 10, weight: 50, package_type: "Package Type X")
    expect { cargo.destroy }.to change { Package.count }.by(-1)
  end

  it "responds to nested_attributes_for for packages" do
    expect(described_class.reflect_on_association(:packages).options).to include(autosave: true, dependent: :destroy)
  end
end
