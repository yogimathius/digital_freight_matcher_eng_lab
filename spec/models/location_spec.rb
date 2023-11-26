# spec/models/location_spec.rb

require 'rails_helper'

RSpec.describe Location, type: :model do
  subject do
    described_class.new(
      latitude: 40.7128, # Example latitude for testing
      longitude: -74.0060 # Example longitude for testing
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without latitude" do
    subject.latitude = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without longitude" do
    subject.longitude = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with latitude greater than 90" do
    subject.latitude = 91
    expect(subject).to_not be_valid
  end

  it "is not valid with latitude less than -90" do
    subject.latitude = -91
    expect(subject).to_not be_valid
  end

  it "is not valid with longitude greater than 180" do
    subject.longitude = 181
    expect(subject).to_not be_valid
  end

  it "is not valid with longitude less than -180" do
    subject.longitude = -181
    expect(subject).to_not be_valid
  end

  it "has many routes" do
    expect(subject).to respond_to(:routes)
  end

  it "has many orders" do
    expect(subject).to respond_to(:orders)
  end
end
