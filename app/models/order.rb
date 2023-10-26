class Order < ApplicationRecord
  belongs_to :origin, class_name: 'Location'
  belongs_to :destination, class_name: 'Location'
  belongs_to :client
  belongs_to :route
  has_one :cargo, dependent: :destroy
end
