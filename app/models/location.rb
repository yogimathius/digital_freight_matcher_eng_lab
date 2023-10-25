class Location < ApplicationRecord
  has_many :routes, dependent: :destroy
  has_many :orders, dependent: :destroy
end
