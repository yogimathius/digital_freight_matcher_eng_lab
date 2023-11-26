# spec/models/order_spec.rb

require 'rails_helper'

RSpec.describe Order, type: :model do
  subject do
    described_class.new(origin_id: 1,
                        destination_id: 2,
                        client_id: 2,
                        route_id: 4)
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without an origin_id" do
    subject.origin_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a destination_id" do
    subject.destination_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a client_id" do
    subject.client_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a route_id" do
    subject.route_id = nil
    expect(subject).to_not be_valid
  end

  it "associates with an origin" do
    expect(subject).to respond_to(:origin)
  end

  it "associates with a destination" do
    expect(subject).to respond_to(:destination)
  end

  it "associates with a client" do
    expect(subject).to respond_to(:client)
  end

  it "associates with a route" do
    expect(subject).to respond_to(:route)
  end

  it "has one cargo" do
    expect(subject).to respond_to(:cargo)
  end

  it "accepts nested attributes for origin" do
    association = described_class.reflect_on_association(:origin)
    expect(association.options).to include(autosave: true)
  end

  it "accepts nested attributes for destination" do
    association = described_class.reflect_on_association(:destination)
    expect(association.options).to include(autosave: true)
  end

  it "accepts nested attributes for cargo" do
    association = described_class.reflect_on_association(:cargo)
    expect(association.options).to include(autosave: true, dependent: :destroy)
  end
end
