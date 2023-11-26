# app/models/location.rb

class Location < ApplicationRecord
  has_many :routes, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
