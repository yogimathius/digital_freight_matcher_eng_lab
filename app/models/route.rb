class Route < ApplicationRecord
  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  has_many :orders, dependent: :destroy
end
