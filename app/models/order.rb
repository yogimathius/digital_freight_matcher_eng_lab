class Order < ApplicationRecord
  belongs_to :location, foreign_key: :destination_id, inverse_of: :orders
  belongs_to :client
  belongs_to :route
end
