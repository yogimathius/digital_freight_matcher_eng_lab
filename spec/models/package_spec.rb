# spec/models/package_spec.rb

require 'rails_helper'

RSpec.describe Package, type: :model do
  subject do
    described_class.new(
      volume: 10,
      weight: 50,
      package_type: 'Package Type X',
      cargo_id: 1
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without volume" do
    subject.volume = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without weight" do
    subject.weight = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without package_type" do
    subject.package_type = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without cargo_id" do
    subject.cargo_id = nil
    expect(subject).to_not be_valid
  end

  it "belongs to a cargo" do
    expect(subject).to respond_to(:cargo)
  end
end
